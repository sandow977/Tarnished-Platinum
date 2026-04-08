#!/usr/bin/env python3

"""
Import Pokemon sprite source assets from an hg-engine checkout into pokeplatinum.

This script is intentionally conservative:
- It only imports a user-provided whitelist of species.
- It copies sprites, icons, and optional .key files from hg-engine.
- It derives normal.pal from the front sprite palette.
- It derives shiny.pal from the back sprite palette, matching hg-engine's pokegra build.
- It generates sprite_data.json from hg-engine metadata plus existing pokeplatinum
  animation presets.
- It can optionally merge the safe "personal data" portion of data.json from
  hg-engine metadata.
- It writes a standard per-species meson.build if needed.

It still does NOT attempt to modify species tables / form registries / learnsets /
evolutions / Pokedex text automatically. Those are expected to be handled separately
as part of roster expansion.
"""

from __future__ import annotations

import argparse
import json
import re
import shutil
import sys
import textwrap
from collections import Counter, defaultdict
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any


MESON_BUILD_TEXT = """species_data_files += files('data.json')

poke_icon_files += files('icon.png')

pokegra_files += files('female_back.png')
pokegra_files += files('male_back.png')
pokegra_files += files('female_front.png')
pokegra_files += files('male_front.png')

pokefoot_files += files('footprint.png')
"""


SPRITE_COPY_PLAN = {
    "male/front.png": "male_front.png",
    "male/back.png": "male_back.png",
    "female/front.png": "female_front.png",
    "female/back.png": "female_back.png",
}

HEIGHT_RE = re.compile(
    r'^heightentry\s+(SPECIES_[A-Z0-9_]+),\s*("null"|-?\d+),\s*("null"|-?\d+),\s*("null"|-?\d+),\s*("null"|-?\d+)'
)
SPRITE_OFFSET_RE = re.compile(
    r"^dataentry\s+(SPECIES_[A-Z0-9_]+),\s*(\d+),\s*(\d+),\s*(-?\d+),\s*(-?\d+),\s*(SHADOW_[A-Z_]+|SHADOW_NO_SHADOW)"
)
ICON_PALETTE_RE = re.compile(
    r"^/\*\s*(SPECIES_[A-Z0-9_]+)\s*\*/\s*\.byte\s+(0x[0-9A-Fa-f]+|\d+)"
)
BASE_EXP_RE = re.compile(r"^\s*\[(SPECIES_[A-Z0-9_]+)\s*\]\s*=\s*(\d+),")
MONDATA_RE = re.compile(r'^mondata\s+(SPECIES_[A-Z0-9_]+),\s*"([^"]*)"')
POKEDEX_STRING_RE = re.compile(r'^[A-Za-z_]+\s+(SPECIES_[A-Z0-9_]+),\s*"([^"]*)"')
HEIGHT_IMPERIAL_RE = re.compile(r"^(\d+)['’](\d+)[\"”]$")
WEIGHT_LBS_RE = re.compile(r"^(\d+(?:\.\d+)?)\s+lbs\.$")

GENDER_RATIO_MAP = {
    0: "GENDER_RATIO_MALE_ONLY",
    31: "GENDER_RATIO_FEMALE_12_5",
    63: "GENDER_RATIO_FEMALE_25",
    127: "GENDER_RATIO_FEMALE_50",
    191: "GENDER_RATIO_FEMALE_75",
    223: "GENDER_RATIO_FEMALE_87_5",
    254: "GENDER_RATIO_FEMALE_ONLY",
    255: "GENDER_RATIO_NO_GENDER",
}

EXP_RATE_MAP = {
    "GROWTH_MEDIUM_FAST": "EXP_RATE_MEDIUM_FAST",
    "GROWTH_ERRATIC": "EXP_RATE_ERRATIC",
    "GROWTH_FLUCTUATING": "EXP_RATE_FLUCTUATING",
    "GROWTH_MEDIUM_SLOW": "EXP_RATE_MEDIUM_SLOW",
    "GROWTH_FAST": "EXP_RATE_FAST",
    "GROWTH_SLOW": "EXP_RATE_SLOW",
}

DEX_ENTRY_MAX_LINES = 3
DEX_ENTRY_WRAP_WIDTH = 34
DEX_ENTRY_MIN_WRAP_WIDTH = 30
MON_DISPLAY_NAME_LEN = 10


@dataclass
class HeightEntry:
    back_female: int | None
    back_male: int | None
    front_female: int | None
    front_male: int | None


@dataclass
class SpriteOffsetEntry:
    front_anim: int
    back_anim: int
    mon_off_y: int
    shadow_x: int
    shadow_size: str


@dataclass
class SpeciesReport:
    target_species: str
    source_species: str
    created_directory: bool = False
    copied_files: list[str] = field(default_factory=list)
    warnings: list[str] = field(default_factory=list)
    errors: list[str] = field(default_factory=list)
    used_template_footprint: str | None = None
    used_template_icon_palette: str | None = None
    used_sprite_timing_donor_front: str | None = None
    used_sprite_timing_donor_back: str | None = None
    generated_sprite_data_from_hg: bool = False
    updated_data_json_from_hg: bool = False
    wrote_meson_build: bool = False

    @property
    def ok(self) -> bool:
        return len(self.errors) == 0


class SpeciesJSONEncoder(json.JSONEncoder):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.indentation_level = 0

    def encode(self, o):
        if isinstance(o, (list, tuple)):
            if self._is_inlinable(o):
                return f"[ {', '.join(self._dump_json(el) for el in o)} ]"
            self.indentation_level += 1
            output = [f"{self.indent_str}{self.encode(el)}" for el in o]
            self.indentation_level -= 1
            joined = ",\n".join(output)
            return "[\n" + joined + "\n" + self.indent_str + "]"
        if isinstance(o, dict):
            self.indentation_level += 1
            output = [
                f"{self.indent_str}{self._dump_json(k)}: {self.encode(v)}"
                for k, v in o.items()
            ]
            self.indentation_level -= 1
            joined = ",\n".join(output)
            return "{\n" + joined + "\n" + self.indent_str + "}"
        return self._dump_json(o)

    def _is_inlinable(self, o):
        if isinstance(o, (list, tuple)):
            return (
                not any(isinstance(el, (list, tuple, dict)) for el in o)
                and len(o) <= 2
                and len(str(o)) - 2 <= 80
            )
        return False

    @property
    def indent_str(self) -> str:
        if isinstance(self.indent, int):
            return " " * (self.indentation_level * self.indent)
        if isinstance(self.indent, str):
            return self.indentation_level * self.indent
        raise ValueError(f"indent must be of type int or str (is: {type(self.indent)})")

    def iterencode(self, o, **kwargs):
        return self.encode(o)

    def _dump_json(self, o: Any) -> str:
        return json.dumps(o, ensure_ascii=self.ensure_ascii)


def parse_args() -> argparse.Namespace:
    repo_root = Path(__file__).resolve().parents[2]
    default_pp_root = repo_root / "res" / "pokemon"

    parser = argparse.ArgumentParser(
        description="Import whitelist sprite assets from hg-engine into pokeplatinum."
    )
    parser.add_argument(
        "--hg-root",
        required=True,
        type=Path,
        help="Path to hg-engine sprite source root, e.g. data/graphics/sprites",
    )
    parser.add_argument(
        "--pp-root",
        type=Path,
        default=default_pp_root,
        help=f"Path to pokeplatinum res/pokemon root (default: {default_pp_root})",
    )
    parser.add_argument(
        "--shiny-root",
        type=Path,
        help="Optional path to an alternate shiny sprite source root with HG-style species folders. If omitted, shiny.pal is derived from hg-root back sprites.",
    )
    parser.add_argument(
        "--species",
        nargs="*",
        default=[],
        help="Target species to import (pokeplatinum folder names).",
    )
    parser.add_argument(
        "--species-file",
        type=Path,
        help="Optional text file listing target species names, one per line.",
    )
    parser.add_argument(
        "--mapping-file",
        type=Path,
        help="Optional JSON mapping of target species names to hg-engine folder names.",
    )
    parser.add_argument(
        "--template-species",
        default="bulbasaur",
        help="Species in pokeplatinum used as a fallback for icon palettes and missing animation timing data.",
    )
    parser.add_argument(
        "--footprint-template",
        default="none",
        help="Species in pokeplatinum whose footprint.png should be copied by default.",
    )
    parser.add_argument(
        "--overwrite",
        action="store_true",
        help="Overwrite existing destination files.",
    )
    parser.add_argument(
        "--skip-keys",
        action="store_true",
        help="Do not copy .png.key files from hg-engine.",
    )
    parser.add_argument(
        "--update-data-json",
        action="store_true",
        help="Merge the safe personal-data fields in data.json from hg-engine metadata. Existing learnsets, evolutions, and Pokedex text are preserved.",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Preview actions without writing files.",
    )
    parser.add_argument(
        "--report",
        type=Path,
        help="Optional path to write a JSON report.",
    )
    return parser.parse_args()


def normalize_species_name(name: str) -> str:
    return name.strip().lower().replace(" ", "_").replace("-", "_")


def species_to_const(name: str) -> str:
    name = name.strip().upper().replace("/", "_")
    name = re.sub(r"[^A-Z0-9_]+", "_", name)
    name = re.sub(r"_+", "_", name).strip("_")
    return f"SPECIES_{name}"


def load_species_list(args: argparse.Namespace) -> list[str]:
    species: list[str] = [normalize_species_name(s) for s in args.species]

    if args.species_file:
        file_lines = args.species_file.read_text(encoding="utf-8").splitlines()
        for line in file_lines:
            line = line.strip()
            if not line or line.startswith("#"):
                continue
            species.append(normalize_species_name(line))

    deduped: list[str] = []
    seen: set[str] = set()
    for species_name in species:
        if species_name not in seen:
            deduped.append(species_name)
            seen.add(species_name)
    return deduped


def load_mapping(mapping_file: Path | None) -> dict[str, str]:
    if mapping_file is None:
        return {}
    raw = json.loads(mapping_file.read_text(encoding="utf-8"))
    return {normalize_species_name(k): normalize_species_name(v) for k, v in raw.items()}


def ensure_dir(path: Path, dry_run: bool) -> bool:
    if path.exists():
        return False
    if not dry_run:
        path.mkdir(parents=True, exist_ok=True)
    return True


def copy_file(
    src: Path,
    dest: Path,
    report: SpeciesReport,
    dry_run: bool,
    overwrite: bool,
) -> None:
    if not src.exists():
        report.errors.append(f"Missing source file: {src}")
        return

    if dest.exists() and not overwrite:
        report.warnings.append(f"Skipped existing file: {dest.name}")
        return

    if not dry_run:
        shutil.copy2(src, dest)
    report.copied_files.append(dest.name)


def is_usable_file(path: Path) -> bool:
    return path.exists() and path.is_file() and path.stat().st_size > 0


def write_text_file(
    dest: Path,
    content: str,
    dry_run: bool,
    overwrite: bool,
) -> bool:
    if dest.exists() and not overwrite:
        return False
    if not dry_run:
        dest.write_text(content, encoding="utf-8", newline="\n")
    return True


def write_json_file(
    dest: Path,
    payload: dict[str, Any],
    dry_run: bool,
    overwrite: bool,
) -> bool:
    if dest.exists() and not overwrite:
        return False
    if not dry_run:
        dest.write_text(
            json.dumps(payload, cls=SpeciesJSONEncoder, indent=4, ensure_ascii=False) + "\n",
            encoding="utf-8",
            newline="\n",
        )
    return True


def try_import_pillow():
    try:
        from PIL import Image  # type: ignore
    except ImportError as exc:
        raise SystemExit(
            "This script requires Pillow for palette extraction.\n"
            "Install it with: py -3 -m pip install pillow"
        ) from exc
    return Image


def extract_palette_colors(png_path: Path) -> list[tuple[int, int, int]]:
    Image = try_import_pillow()
    with Image.open(png_path) as img:
        if img.mode != "P":
            img = img.convert("RGBA").quantize(colors=16)

        raw_palette = img.getpalette()
        if raw_palette is None:
            raise ValueError(f"No palette data found in {png_path}")
        if len(raw_palette) < 16 * 3:
            raw_palette = raw_palette + [0] * (16 * 3 - len(raw_palette))

        colors: list[tuple[int, int, int]] = []
        for i in range(16):
            base = i * 3
            colors.append(
                (
                    raw_palette[base],
                    raw_palette[base + 1],
                    raw_palette[base + 2],
                )
            )
        return colors


def write_jasc_palette(
    png_path: Path,
    dest_pal: Path,
    dry_run: bool,
    overwrite: bool,
) -> bool:
    if dest_pal.exists() and not overwrite:
        return False

    colors = extract_palette_colors(png_path)
    lines = ["JASC-PAL", "0100", "16"]
    lines.extend(f"{r} {g} {b}" for r, g, b in colors)
    text = "\n".join(lines) + "\n"

    if not dry_run:
        dest_pal.write_text(text, encoding="ascii", newline="\n")
    return True


def pick_sprite(species_dir: Path, face: str) -> Path | None:
    for rel in (f"male/{face}.png", f"female/{face}.png"):
        candidate = species_dir / rel
        if is_usable_file(candidate):
            return candidate
    return None


def sprite_fallback_source(species_dir: Path, gender: str, face: str) -> tuple[Path | None, str | None]:
    preferred = species_dir / gender / f"{face}.png"
    if is_usable_file(preferred):
        return preferred, None

    alternate_gender = "female" if gender == "male" else "male"
    alternate = species_dir / alternate_gender / f"{face}.png"
    if is_usable_file(alternate):
        return alternate, alternate_gender

    if preferred.exists() and preferred.is_file() and preferred.stat().st_size == 0:
        return None, f"{preferred} is zero-byte"
    return None, None


def copy_template_file(
    pp_root: Path,
    template_species: str,
    source_name: str,
    dest: Path,
    dry_run: bool,
    overwrite: bool,
) -> bool:
    template_path = pp_root / template_species / source_name
    if not template_path.exists():
        raise FileNotFoundError(f"Template file missing: {template_path}")

    if dest.exists() and not overwrite:
        return False

    if not dry_run:
        shutil.copy2(template_path, dest)
    return True


def read_json_file(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8"))


def resolve_source_species(hg_root: Path, mapped_name: str) -> Path:
    direct = hg_root / mapped_name
    if direct.exists():
        return direct
    raise FileNotFoundError(f"Could not find source species folder: {direct}")


def infer_hg_repo_root(hg_root: Path) -> Path:
    candidates = [hg_root, *hg_root.parents]
    for candidate in candidates:
        if (candidate / "armips" / "data" / "mondata.s").exists() and (
            candidate / "armips" / "data" / "heighttable.s"
        ).exists():
            return candidate
    raise FileNotFoundError(
        "Could not infer hg-engine repo root from --hg-root. "
        "Expected to find armips/data/mondata.s somewhere above it."
    )


def parse_nullable_int(token: str) -> int | None:
    if token == '"null"':
        return None
    return int(token)


def normalize_shadow_size(shadow_size: str) -> str:
    if shadow_size == "SHADOW_NO_SHADOW":
        return "SHADOW_SIZE_NONE"
    return shadow_size


def parse_heighttable(path: Path) -> dict[str, HeightEntry]:
    result: dict[str, HeightEntry] = {}
    for line in path.read_text(encoding="utf-8").splitlines():
        match = HEIGHT_RE.match(line.strip())
        if not match:
            continue
        species = match.group(1)
        result[species] = HeightEntry(
            back_female=parse_nullable_int(match.group(2)),
            back_male=parse_nullable_int(match.group(3)),
            front_female=parse_nullable_int(match.group(4)),
            front_male=parse_nullable_int(match.group(5)),
        )
    return result


def parse_spriteoffsets(path: Path) -> dict[str, SpriteOffsetEntry]:
    result: dict[str, SpriteOffsetEntry] = {}
    for line in path.read_text(encoding="utf-8").splitlines():
        match = SPRITE_OFFSET_RE.match(line.strip())
        if not match:
            continue
        species = match.group(1)
        result[species] = SpriteOffsetEntry(
            front_anim=int(match.group(2)),
            back_anim=int(match.group(3)),
            mon_off_y=int(match.group(4)),
            shadow_x=int(match.group(5)),
            shadow_size=normalize_shadow_size(match.group(6)),
        )
    return result


def parse_icon_palette_table(path: Path) -> dict[str, int]:
    result: dict[str, int] = {}
    for line in path.read_text(encoding="utf-8").splitlines():
        match = ICON_PALETTE_RE.match(line.strip())
        if not match:
            continue
        result[match.group(1)] = int(match.group(2), 0)
    return result


def parse_base_exp_table(path: Path) -> dict[str, int]:
    result: dict[str, int] = {}
    for line in path.read_text(encoding="utf-8").splitlines():
        match = BASE_EXP_RE.match(line)
        if match:
            result[match.group(1)] = int(match.group(2))
    return result


def split_csv_tail(line: str, directive: str) -> list[str]:
    tail = line[len(directive) :].split("//", 1)[0].strip()
    return [part.strip() for part in tail.split(",")]


def parse_mondata(path: Path, base_exp_table: dict[str, int]) -> dict[str, dict[str, Any]]:
    result: dict[str, dict[str, Any]] = {}
    current_species: str | None = None
    current: dict[str, Any] | None = None

    def flush() -> None:
        nonlocal current_species, current
        if current_species is None or current is None:
            return
        result[current_species] = current
        current_species = None
        current = None

    for raw_line in path.read_text(encoding="utf-8").splitlines():
        line = raw_line.strip()
        if not line:
            continue

        mon_match = MONDATA_RE.match(line)
        if mon_match:
            flush()
            current_species = mon_match.group(1)
            current = {}
            current["display_name"] = mon_match.group(2)
            continue

        if current is None or current_species is None:
            continue

        if line.startswith("basestats "):
            values = [int(v) for v in split_csv_tail(line, "basestats ")]
            current["base_stats"] = {
                "hp": values[0],
                "attack": values[1],
                "defense": values[2],
                "speed": values[3],
                "special_attack": values[4],
                "special_defense": values[5],
            }
        elif line.startswith("types "):
            current["types"] = split_csv_tail(line, "types ")
        elif line.startswith("catchrate "):
            current["catch_rate"] = int(split_csv_tail(line, "catchrate ")[0])
        elif line.startswith("baseexp "):
            base_exp = int(split_csv_tail(line, "baseexp ")[0])
            if base_exp == 0 and current_species in base_exp_table:
                base_exp = base_exp_table[current_species]
            current["base_exp_reward"] = base_exp
        elif line.startswith("evyields "):
            values = [int(v) for v in split_csv_tail(line, "evyields ")]
            current["ev_yields"] = {
                "hp": values[0],
                "attack": values[1],
                "defense": values[2],
                "speed": values[3],
                "special_attack": values[4],
                "special_defense": values[5],
            }
        elif line.startswith("items "):
            items = split_csv_tail(line, "items ")
            current["held_items"] = {
                "common": items[0],
                "rare": items[1],
            }
        elif line.startswith("genderratio "):
            ratio_value = int(split_csv_tail(line, "genderratio ")[0])
            current["gender_ratio"] = GENDER_RATIO_MAP.get(
                ratio_value, "GENDER_RATIO_FEMALE_50"
            )
        elif line.startswith("eggcycles "):
            current["hatch_cycles"] = int(split_csv_tail(line, "eggcycles ")[0])
        elif line.startswith("basefriendship "):
            current["base_friendship"] = int(split_csv_tail(line, "basefriendship ")[0])
        elif line.startswith("growthrate "):
            growth = split_csv_tail(line, "growthrate ")[0]
            current["exp_rate"] = EXP_RATE_MAP.get(growth, "EXP_RATE_MEDIUM_FAST")
        elif line.startswith("egggroups "):
            current["egg_groups"] = split_csv_tail(line, "egggroups ")
        elif line.startswith("abilities "):
            current["abilities"] = split_csv_tail(line, "abilities ")
        elif line.startswith("runchance "):
            current["safari_flee_rate"] = int(split_csv_tail(line, "runchance ")[0])
        elif line.startswith("colorflip "):
            parts = split_csv_tail(line, "colorflip ")
            color = parts[0].replace("BODY_COLOR_", "MON_COLOR_")
            current["body_color"] = color
            current["flip_sprite"] = bool(int(parts[1]))
        elif line.startswith("mondexentry "):
            match = POKEDEX_STRING_RE.match(line)
            if match:
                current["dex_entry_en"] = match.group(2)
        elif line.startswith("mondexclassification "):
            match = POKEDEX_STRING_RE.match(line)
            if match:
                current["dex_category_en"] = match.group(2)
        elif line.startswith("mondexheight "):
            match = POKEDEX_STRING_RE.match(line)
            if match:
                current["dex_height_imperial"] = match.group(2)
        elif line.startswith("mondexweight "):
            match = POKEDEX_STRING_RE.match(line)
            if match:
                current["dex_weight_imperial"] = match.group(2)

    flush()
    return result


def build_animation_mapping(
    pp_root: Path,
    hg_offsets: dict[str, SpriteOffsetEntry],
) -> tuple[dict[int, int], dict[int, int]]:
    front_counts: dict[int, Counter[int]] = defaultdict(Counter)
    back_counts: dict[int, Counter[int]] = defaultdict(Counter)

    for species_dir in pp_root.iterdir():
        if not species_dir.is_dir():
            continue

        sprite_path = species_dir / "sprite_data.json"
        if not sprite_path.exists():
            continue

        species_const = species_to_const(species_dir.name)
        if species_const not in hg_offsets:
            continue

        sprite = read_json_file(sprite_path)
        front_counts[hg_offsets[species_const].front_anim][int(sprite["front"]["animation"])] += 1
        back_counts[hg_offsets[species_const].back_anim][int(sprite["back"]["animation"])] += 1

    def collapse(counters: dict[int, Counter[int]]) -> dict[int, int]:
        resolved: dict[int, int] = {}
        for hg_anim, target_counts in counters.items():
            if not target_counts:
                continue
            max_count = max(target_counts.values())
            candidates = sorted(anim for anim, count in target_counts.items() if count == max_count)
            resolved[hg_anim] = hg_anim if hg_anim in candidates else candidates[0]
        return resolved

    return collapse(front_counts), collapse(back_counts)


def build_animation_presets(
    pp_root: Path,
) -> tuple[dict[int, dict[str, Any]], dict[int, dict[str, Any]]]:
    face_counts: dict[str, dict[int, Counter[str]]] = {
        "front": defaultdict(Counter),
        "back": defaultdict(Counter),
    }
    face_payloads: dict[str, dict[str, dict[str, Any]]] = {"front": {}, "back": {}}
    face_donors: dict[str, dict[str, str]] = {"front": {}, "back": {}}

    for sprite_path in pp_root.rglob("sprite_data.json"):
        data = read_json_file(sprite_path)
        donor_name = str(sprite_path.parent.relative_to(pp_root)).replace("\\", "/")
        for face_name in ("front", "back"):
            face = data[face_name]
            anim = int(face["animation"])
            payload = {
                "cry_delay": int(face["cry_delay"]),
                "start_delay": int(face["start_delay"]),
                "frames": face["frames"],
            }
            payload_key = json.dumps(payload, sort_keys=True, separators=(",", ":"))
            face_counts[face_name][anim][payload_key] += 1
            face_payloads[face_name][payload_key] = payload
            face_donors[face_name][payload_key] = donor_name

    presets: dict[str, dict[int, dict[str, Any]]] = {"front": {}, "back": {}}
    for face_name in ("front", "back"):
        for anim, counter in face_counts[face_name].items():
            best_count = max(counter.values())
            best_keys = [key for key, count in counter.items() if count == best_count]
            best_keys.sort(key=lambda key: (face_donors[face_name][key], key))
            payload_key = best_keys[0]
            presets[face_name][anim] = {
                **face_payloads[face_name][payload_key],
                "__donor": face_donors[face_name][payload_key],
            }
    return presets["front"], presets["back"]


def resolve_gender_offset(primary: int | None, secondary: int | None) -> int:
    if primary is not None:
        return primary
    if secondary is not None:
        return secondary
    return 0


def build_face_from_preset(
    face_name: str,
    anim: int,
    y_offsets: dict[str, int],
    preset: dict[str, Any],
    addl_y_offset: int | None = None,
) -> dict[str, Any]:
    face = {
        "y_offset": y_offsets,
        "animation": anim,
        "cry_delay": preset["cry_delay"],
        "start_delay": preset["start_delay"],
        "frames": preset["frames"],
    }
    if face_name == "front" and addl_y_offset is not None:
        face["addl_y_offset"] = addl_y_offset
    return face


def generate_sprite_data(
    template_sprite_data: dict[str, Any],
    species_const: str,
    height_entry: HeightEntry | None,
    sprite_offset: SpriteOffsetEntry | None,
    front_anim_map: dict[int, int],
    back_anim_map: dict[int, int],
    front_presets: dict[int, dict[str, Any]],
    back_presets: dict[int, dict[str, Any]],
) -> tuple[dict[str, Any], list[str], str | None, str | None]:
    warnings: list[str] = []

    if height_entry is None:
        warnings.append(
            f"No heighttable entry found for {species_const}; using template sprite y offsets"
        )
    if sprite_offset is None:
        warnings.append(
            f"No spriteoffsets entry found for {species_const}; using template animation/shadow data"
        )

    if height_entry is None or sprite_offset is None:
        return template_sprite_data, warnings, None, None

    front_anim = front_anim_map.get(sprite_offset.front_anim, sprite_offset.front_anim)
    back_anim = back_anim_map.get(sprite_offset.back_anim, sprite_offset.back_anim)

    front_preset = front_presets.get(front_anim)
    back_preset = back_presets.get(back_anim)

    if front_preset is None:
        warnings.append(
            f"No front timing preset found for animation {front_anim}; using template front timing"
        )
        front_preset = {
            "cry_delay": template_sprite_data["front"]["cry_delay"],
            "start_delay": template_sprite_data["front"]["start_delay"],
            "frames": template_sprite_data["front"]["frames"],
            "__donor": None,
        }

    if back_preset is None:
        warnings.append(
            f"No back timing preset found for animation {back_anim}; using template back timing"
        )
        back_preset = {
            "cry_delay": template_sprite_data["back"]["cry_delay"],
            "start_delay": template_sprite_data["back"]["start_delay"],
            "frames": template_sprite_data["back"]["frames"],
            "__donor": None,
        }

    front_offsets = {
        "female": resolve_gender_offset(height_entry.front_female, height_entry.front_male),
        "male": resolve_gender_offset(height_entry.front_male, height_entry.front_female),
    }
    back_offsets = {
        "female": resolve_gender_offset(height_entry.back_female, height_entry.back_male),
        "male": resolve_gender_offset(height_entry.back_male, height_entry.back_female),
    }

    data = {
        "front": build_face_from_preset(
            "front",
            front_anim,
            front_offsets,
            front_preset,
            addl_y_offset=sprite_offset.mon_off_y,
        ),
        "back": build_face_from_preset("back", back_anim, back_offsets, back_preset),
        "shadow": {
            "x_offset": sprite_offset.shadow_x,
            "size": normalize_shadow_size(sprite_offset.shadow_size),
        },
    }

    return data, warnings, front_preset.get("__donor"), back_preset.get("__donor")


def load_template_data(pp_root: Path, template_species: str) -> tuple[dict[str, Any], dict[str, Any]]:
    sprite_template_path = pp_root / template_species / "sprite_data.json"
    data_template_path = pp_root / template_species / "data.json"

    if not sprite_template_path.exists():
        raise FileNotFoundError(f"Template sprite_data.json missing: {sprite_template_path}")
    if not data_template_path.exists():
        raise FileNotFoundError(f"Template data.json missing: {data_template_path}")

    return read_json_file(sprite_template_path), read_json_file(data_template_path)


def titlecase_species_name(name: str) -> str:
    tokens = re.split(r"([ _-])", name)
    out: list[str] = []
    for token in tokens:
        if token in {" ", "_", "-"}:
            out.append(token)
        elif token:
            out.append(token.capitalize())
    return "".join(out)


def shorten_display_name(name: str) -> str:
    display_name = name.upper().replace("â€™", "'").replace("’", "'").strip()

    if len(display_name) <= MON_DISPLAY_NAME_LEN:
        return display_name

    special_suffixes = {
        "ROCK STAR": "R",
        "POP STAR": "P",
    }

    for suffix, replacement in special_suffixes.items():
        if display_name.endswith(suffix):
            base = display_name[: -len(suffix)].rstrip()
            display_name = f"{base} {replacement}".strip()
            break

    token_map = {
        "ALOLAN": "A",
        "GALARIAN": "G",
        "HISUIAN": "H",
        "PALDEAN": "P",
        "BELLE": "B",
        "LIBRE": "L",
        "POPSTAR": "P",
        "ROCKSTAR": "R",
        "WINTER": "W",
        "SUMMER": "S",
        "AUTUMN": "A",
        "SPRING": "S",
    }

    tokens = display_name.split()
    if len(tokens) >= 2:
        tokens[-1] = token_map.get(tokens[-1], tokens[-1])
        display_name = " ".join(tokens)

    if len(display_name) <= MON_DISPLAY_NAME_LEN:
        return display_name

    if len(tokens) >= 2 and len(tokens[-1]) == 1:
        base = "".join(tokens[:-1])
        suffix = tokens[-1]
        compact = f"{base}{suffix}"
        if len(compact) <= MON_DISPLAY_NAME_LEN:
            return compact

        base_limit = MON_DISPLAY_NAME_LEN - len(suffix)
        return f"{base[:base_limit]}{suffix}"

    return display_name[:MON_DISPLAY_NAME_LEN]


def split_dex_entry_lines(text: str) -> list[str]:
    normalized = " ".join(
        re.sub(r"\s+", " ", part).strip()
        for part in text.replace("\r", "").replace("\\n", "\n").split("\n")
        if part.strip()
    )
    if not normalized:
        return []

    for width in range(DEX_ENTRY_WRAP_WIDTH, DEX_ENTRY_MIN_WRAP_WIDTH - 1, -1):
        wrapped = textwrap.wrap(
            normalized,
            width=width,
            break_long_words=False,
            break_on_hyphens=False,
        )
        if len(wrapped) <= DEX_ENTRY_MAX_LINES:
            return [
                line + ("\n" if idx < len(wrapped) - 1 else "")
                for idx, line in enumerate(wrapped)
            ]

    wrapped = textwrap.wrap(
        normalized,
        width=DEX_ENTRY_MIN_WRAP_WIDTH,
        break_long_words=False,
        break_on_hyphens=False,
    )
    head = wrapped[: DEX_ENTRY_MAX_LINES - 1]
    tail = " ".join(wrapped[DEX_ENTRY_MAX_LINES - 1 :])
    tail_words = tail.split()
    while tail_words and len(" ".join(tail_words)) > DEX_ENTRY_MIN_WRAP_WIDTH:
        tail_words.pop()
    tail = " ".join(tail_words)
    wrapped = [*head, tail]

    return [
        line + ("\n" if idx < len(wrapped) - 1 else "")
        for idx, line in enumerate(wrapped)
    ]


def parse_height_to_decimeters(height_text: str) -> int | None:
    match = HEIGHT_IMPERIAL_RE.match(height_text)
    if not match:
        return None
    feet = int(match.group(1))
    inches = int(match.group(2))
    total_inches = (feet * 12) + inches
    meters = total_inches * 0.0254
    return int(round(meters * 10))


def parse_weight_to_hectograms(weight_text: str) -> int | None:
    match = WEIGHT_LBS_RE.match(weight_text)
    if not match:
        return None
    pounds = float(match.group(1))
    kilograms = pounds * 0.45359237
    return int(round(kilograms * 10))


def merge_pokedex_data(
    data: dict[str, Any],
    hg_data: dict[str, Any],
    template_data: dict[str, Any],
    species_name_hint: str,
    warnings: list[str],
) -> None:
    base_pokedex = data.get("pokedex_data")
    if not isinstance(base_pokedex, dict):
        base_pokedex = json.loads(json.dumps(template_data.get("pokedex_data", {})))
        data["pokedex_data"] = base_pokedex
        warnings.append("pokedex_data was missing; seeded from template species")

    display_name = hg_data.get("display_name", "")
    if not display_name or display_name == "-----":
        display_name = titlecase_species_name(species_name_hint)
        warnings.append(
            "HG mondata display name was missing or placeholder; used a title-cased species name"
        )

    category = hg_data.get("dex_category_en")
    entry = hg_data.get("dex_entry_en")
    height_text = hg_data.get("dex_height_imperial")
    weight_text = hg_data.get("dex_weight_imperial")

    if height_text:
        height_dm = parse_height_to_decimeters(height_text)
        if height_dm is not None:
            base_pokedex["height"] = height_dm
        else:
            warnings.append(f"Could not parse HG dex height '{height_text}'")

    if weight_text:
        weight_hg = parse_weight_to_hectograms(weight_text)
        if weight_hg is not None:
            base_pokedex["weight"] = weight_hg
        else:
            warnings.append(f"Could not parse HG dex weight '{weight_text}'")

    en_block = base_pokedex.get("en")
    if not isinstance(en_block, dict):
        en_block = {}
        base_pokedex["en"] = en_block

    shortened_name = shorten_display_name(display_name)
    if shortened_name != display_name.upper():
        warnings.append(
            f"HG mondata display name was longer than {MON_DISPLAY_NAME_LEN}; shortened to fit battle/name buffers"
        )
    en_block["name"] = shortened_name
    if category:
        en_block["category"] = category
    if entry:
        en_block["entry_text"] = split_dex_entry_lines(entry)


def build_data_json(
    current_data: dict[str, Any] | None,
    hg_data: dict[str, Any],
    template_data: dict[str, Any],
    species_name_hint: str,
    hg_icon_palette: int | None,
) -> tuple[dict[str, Any], list[str], bool]:
    warnings: list[str] = []
    created_new = current_data is None

    data = {} if current_data is None else json.loads(json.dumps(current_data))
    data.update(
        {
            "base_stats": hg_data["base_stats"],
            "types": hg_data["types"],
            "catch_rate": hg_data["catch_rate"],
            "base_exp_reward": hg_data["base_exp_reward"],
            "ev_yields": hg_data["ev_yields"],
            "held_items": hg_data["held_items"],
            "gender_ratio": hg_data["gender_ratio"],
            "hatch_cycles": hg_data["hatch_cycles"],
            "base_friendship": hg_data["base_friendship"],
            "exp_rate": hg_data["exp_rate"],
            "egg_groups": hg_data["egg_groups"],
            "abilities": hg_data["abilities"],
            "safari_flee_rate": hg_data["safari_flee_rate"],
            "body_color": hg_data["body_color"],
            "flip_sprite": hg_data["flip_sprite"],
        }
    )

    if hg_icon_palette is not None:
        data["icon_palette"] = hg_icon_palette
    elif "icon_palette" not in data:
        if "icon_palette" in template_data:
            data["icon_palette"] = template_data["icon_palette"]
            warnings.append(
                "icon_palette was missing; copied from template species"
            )
        else:
            data["icon_palette"] = 0
            warnings.append(
                "icon_palette was missing and no template value was available; defaulted to 0"
            )

    learnset = data.get("learnset")
    if not isinstance(learnset, dict):
        learnset = {}
    learnset.setdefault("by_level", [])
    learnset.setdefault("by_tm", [])
    data["learnset"] = learnset

    data.setdefault("evolutions", [])
    merge_pokedex_data(data, hg_data, template_data, species_name_hint, warnings)

    if created_new:
        warnings.append(
            "Created a minimal data.json skeleton. Learnsets, evolutions, icon_palette, footprint, and Pokedex data should still be reviewed."
        )
    else:
        warnings.append(
            "Merged personal-data fields from hg-engine into existing data.json and preserved the remaining sections."
        )

    return data, warnings, created_new


def import_species(
    hg_root: Path,
    pp_root: Path,
    shiny_root: Path | None,
    target_species: str,
    source_species: str,
    template_species: str,
    footprint_template: str,
    dry_run: bool,
    overwrite: bool,
    skip_keys: bool,
    update_data_json: bool,
    template_sprite_data: dict[str, Any],
    template_data_json: dict[str, Any],
    height_map: dict[str, HeightEntry],
    sprite_offsets_map: dict[str, SpriteOffsetEntry],
    icon_palette_map: dict[str, int],
    personal_data_map: dict[str, dict[str, Any]],
    front_anim_map: dict[int, int],
    back_anim_map: dict[int, int],
    front_presets: dict[int, dict[str, Any]],
    back_presets: dict[int, dict[str, Any]],
) -> SpeciesReport:
    report = SpeciesReport(target_species=target_species, source_species=source_species)

    try:
        src_dir = resolve_source_species(hg_root, source_species)
    except FileNotFoundError as exc:
        report.errors.append(str(exc))
        return report

    shiny_src_dir: Path | None = None
    if shiny_root is not None:
        try:
            shiny_src_dir = resolve_source_species(shiny_root, source_species)
        except FileNotFoundError:
            report.warnings.append(
                f"No shiny source folder found for '{source_species}'; shiny.pal will use fallback behavior"
            )

    dest_dir = pp_root / target_species
    report.created_directory = ensure_dir(dest_dir, dry_run)

    for src_rel, dest_name in SPRITE_COPY_PLAN.items():
        gender, face_name = src_rel.split("/")
        face_name = face_name.removesuffix(".png")
        src, fallback_gender = sprite_fallback_source(src_dir, gender, face_name)
        dest = dest_dir / dest_name

        if src is None:
            report.errors.append(f"Missing usable source sprite for {target_species}: {src_dir / src_rel}")
            continue

        copy_file(src, dest, report, dry_run, overwrite)

        if fallback_gender is not None:
            report.warnings.append(
                f"{dest_name} reused {fallback_gender}_{face_name}.png because {gender}_{face_name}.png was missing or zero-byte"
            )

        if not skip_keys:
            key_src = src.with_suffix(src.suffix + ".key")
            key_dest = dest.with_suffix(dest.suffix + ".key")
            copy_file(key_src, key_dest, report, dry_run, overwrite)

    copy_file(src_dir / "icon.png", dest_dir / "icon.png", report, dry_run, overwrite)

    meson_written = write_text_file(
        dest_dir / "meson.build",
        MESON_BUILD_TEXT,
        dry_run=dry_run,
        overwrite=overwrite,
    )
    report.wrote_meson_build = meson_written
    if meson_written:
        report.copied_files.append("meson.build")

    front_palette_source = pick_sprite(src_dir, "front")
    normal_pal = dest_dir / "normal.pal"
    shiny_pal = dest_dir / "shiny.pal"

    if front_palette_source is not None:
        try:
            normal_written = write_jasc_palette(
                front_palette_source,
                normal_pal,
                dry_run=dry_run,
                overwrite=overwrite,
            )
            if normal_written:
                report.copied_files.append("normal.pal")
        except Exception as exc:  # noqa: BLE001
            report.errors.append(f"Failed to generate normal.pal: {exc}")
    else:
        report.errors.append("Could not find a front sprite to derive normal.pal")

    shiny_palette_source: Path | None = None
    if shiny_src_dir is not None:
        shiny_palette_source = pick_sprite(shiny_src_dir, "back")
    if shiny_palette_source is None:
        shiny_palette_source = pick_sprite(src_dir, "back")

    if shiny_palette_source is not None:
        try:
            shiny_written = write_jasc_palette(
                shiny_palette_source,
                shiny_pal,
                dry_run=dry_run,
                overwrite=overwrite,
            )
            if shiny_written:
                report.copied_files.append("shiny.pal")
        except Exception as exc:  # noqa: BLE001
            report.errors.append(f"Failed to generate shiny.pal: {exc}")
    else:
        report.errors.append(
            "Could not create shiny.pal because no back sprite palette source was available"
        )

    species_const = species_to_const(source_species)
    sprite_data, sprite_warnings, front_donor, back_donor = generate_sprite_data(
        template_sprite_data=template_sprite_data,
        species_const=species_const,
        height_entry=height_map.get(species_const),
        sprite_offset=sprite_offsets_map.get(species_const),
        front_anim_map=front_anim_map,
        back_anim_map=back_anim_map,
        front_presets=front_presets,
        back_presets=back_presets,
    )
    report.warnings.extend(sprite_warnings)
    report.used_sprite_timing_donor_front = front_donor
    report.used_sprite_timing_donor_back = back_donor
    sprite_data_written = write_json_file(
        dest_dir / "sprite_data.json",
        sprite_data,
        dry_run=dry_run,
        overwrite=overwrite,
    )
    if sprite_data_written:
        report.copied_files.append("sprite_data.json")
        report.generated_sprite_data_from_hg = True
        if front_donor:
            report.warnings.append(
                f"Front timing/frames derived from animation donor '{front_donor}'"
            )
        if back_donor:
            report.warnings.append(
                f"Back timing/frames derived from animation donor '{back_donor}'"
            )

    try:
        footprint_written = copy_template_file(
            pp_root,
            footprint_template,
            "footprint.png",
            dest_dir / "footprint.png",
            dry_run=dry_run,
            overwrite=overwrite,
        )
        if footprint_written:
            report.copied_files.append("footprint.png")
            report.used_template_footprint = footprint_template
            report.warnings.append(
                f"footprint.png copied from template species '{footprint_template}'"
            )
    except FileNotFoundError as exc:
        report.errors.append(str(exc))

    data_json_path = dest_dir / "data.json"
    if update_data_json:
        hg_personal = personal_data_map.get(species_const)
        if hg_personal is None:
            report.errors.append(
                f"No hg-engine mondata entry found for {species_const}; could not update data.json"
            )
        else:
            current_data = read_json_file(data_json_path) if data_json_path.exists() else None
            data_json, data_warnings, created_new = build_data_json(
                current_data=current_data,
                hg_data=hg_personal,
                template_data=template_data_json,
                species_name_hint=target_species,
                hg_icon_palette=icon_palette_map.get(species_const),
            )
            if (
                icon_palette_map.get(species_const) is None
                and "icon_palette" not in (current_data or {})
                and "icon_palette" in template_data_json
            ):
                report.used_template_icon_palette = template_species
            report.warnings.extend(data_warnings)
            data_written = write_json_file(
                data_json_path,
                data_json,
                dry_run=dry_run,
                overwrite=overwrite or created_new,
            )
            if data_written:
                report.copied_files.append("data.json")
                report.updated_data_json_from_hg = True
    elif not data_json_path.exists():
        report.warnings.append(
            "data.json is missing in the destination species folder; use --update-data-json to create a minimal HG-backed skeleton"
        )

    return report


def report_to_json(reports: list[SpeciesReport]) -> list[dict[str, Any]]:
    return [
        {
            "target_species": r.target_species,
            "source_species": r.source_species,
            "ok": r.ok,
            "created_directory": r.created_directory,
            "copied_files": r.copied_files,
            "warnings": r.warnings,
            "errors": r.errors,
            "used_template_footprint": r.used_template_footprint,
            "used_template_icon_palette": r.used_template_icon_palette,
            "used_sprite_timing_donor_front": r.used_sprite_timing_donor_front,
            "used_sprite_timing_donor_back": r.used_sprite_timing_donor_back,
            "generated_sprite_data_from_hg": r.generated_sprite_data_from_hg,
            "updated_data_json_from_hg": r.updated_data_json_from_hg,
            "wrote_meson_build": r.wrote_meson_build,
        }
        for r in reports
    ]


def print_summary(reports: list[SpeciesReport], dry_run: bool) -> None:
    action = "Dry run summary" if dry_run else "Import summary"
    print(f"\n{action}")
    print("=" * len(action))

    for r in reports:
        status = "OK" if r.ok else "ERROR"
        print(f"[{status}] {r.target_species} <- {r.source_species}")
        for warning in r.warnings:
            print(f"  warning: {warning}")
        for error in r.errors:
            print(f"  error: {error}")


def main() -> int:
    args = parse_args()

    species = load_species_list(args)
    if not species:
        print("No species were provided. Use --species or --species-file.", file=sys.stderr)
        return 2

    hg_repo_root = infer_hg_repo_root(args.hg_root)
    template_species = normalize_species_name(args.template_species)
    footprint_template = normalize_species_name(args.footprint_template)

    mapping = load_mapping(args.mapping_file)
    template_sprite_data, template_data_json = load_template_data(args.pp_root, template_species)

    height_map = parse_heighttable(hg_repo_root / "armips" / "data" / "heighttable.s")
    sprite_offsets_map = parse_spriteoffsets(
        hg_repo_root / "armips" / "data" / "spriteoffsets.s"
    )
    icon_palette_map = parse_icon_palette_table(
        hg_repo_root / "armips" / "data" / "iconpalettetable.s"
    )
    base_exp_table = parse_base_exp_table(hg_repo_root / "data" / "BaseExperienceTable.c")
    personal_data_map = parse_mondata(hg_repo_root / "armips" / "data" / "mondata.s", base_exp_table)

    front_anim_map, back_anim_map = build_animation_mapping(args.pp_root, sprite_offsets_map)
    front_presets, back_presets = build_animation_presets(args.pp_root)

    reports: list[SpeciesReport] = []

    for target_species in species:
        source_species = mapping.get(target_species, target_species)
        reports.append(
            import_species(
                hg_root=args.hg_root,
                pp_root=args.pp_root,
                shiny_root=args.shiny_root,
                target_species=target_species,
                source_species=source_species,
                template_species=template_species,
                footprint_template=footprint_template,
                dry_run=args.dry_run,
                overwrite=args.overwrite,
                skip_keys=args.skip_keys,
                update_data_json=args.update_data_json,
                template_sprite_data=template_sprite_data,
                template_data_json=template_data_json,
                height_map=height_map,
                sprite_offsets_map=sprite_offsets_map,
                icon_palette_map=icon_palette_map,
                personal_data_map=personal_data_map,
                front_anim_map=front_anim_map,
                back_anim_map=back_anim_map,
                front_presets=front_presets,
                back_presets=back_presets,
            )
        )

    print_summary(reports, args.dry_run)

    if args.report:
        payload = report_to_json(reports)
        if not args.dry_run:
            args.report.write_text(json.dumps(payload, indent=2), encoding="utf-8")
        else:
            print(f"\nReport would be written to: {args.report}")

    return 1 if any(not r.ok for r in reports) else 0


if __name__ == "__main__":
    raise SystemExit(main())
