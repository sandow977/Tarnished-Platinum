#!/usr/bin/env python3

"""
Generate pokeplatinum shiny.pal files from a shiny sprite source tree.

Primary mode:
- Read shiny source PNGs from an HG-style folder tree.
- Extract the first 16 colors from a back sprite palette.
- Write JASC-PAL shiny.pal files into pokeplatinum species folders.

Fallback mode:
- Copy shiny.pal from another pokeplatinum species via a mapping file.

This script does not modify normal.pal, data.json, sprite_data.json, or any
species registries. It only creates or replaces shiny.pal files.
"""

from __future__ import annotations

import argparse
import json
import shutil
import sys
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any


@dataclass
class PaletteReport:
    target_species: str
    source_species: str | None = None
    donor_species: str | None = None
    wrote_palette: bool = False
    warnings: list[str] = field(default_factory=list)
    errors: list[str] = field(default_factory=list)

    @property
    def ok(self) -> bool:
        return len(self.errors) == 0


def parse_args() -> argparse.Namespace:
    repo_root = Path(__file__).resolve().parents[2]
    default_pp_root = repo_root / "res" / "pokemon"

    parser = argparse.ArgumentParser(
        description="Generate shiny.pal files for pokeplatinum species."
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
        help="Optional HG-style shiny sprite root. If given, PNGs here are the preferred source.",
    )
    parser.add_argument(
        "--species",
        nargs="*",
        default=[],
        help="Target species to process.",
    )
    parser.add_argument(
        "--species-file",
        type=Path,
        help="Optional text file listing target species names, one per line.",
    )
    parser.add_argument(
        "--mapping-file",
        type=Path,
        help="Optional JSON mapping target species -> shiny source species folder name.",
    )
    parser.add_argument(
        "--palette-map",
        type=Path,
        help="Optional JSON mapping target species -> donor species whose shiny.pal should be copied.",
    )
    parser.add_argument(
        "--overwrite",
        action="store_true",
        help="Overwrite existing shiny.pal files.",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Preview actions without writing files.",
    )
    parser.add_argument(
        "--report",
        type=Path,
        help="Optional JSON report output path.",
    )
    return parser.parse_args()


def normalize_species_name(name: str) -> str:
    return name.strip().lower().replace(" ", "_").replace("-", "_")


def load_species_list(args: argparse.Namespace) -> list[str]:
    species = [normalize_species_name(s) for s in args.species]

    if args.species_file:
        for line in args.species_file.read_text(encoding="utf-8").splitlines():
            line = line.strip()
            if not line or line.startswith("#"):
                continue
            species.append(normalize_species_name(line))

    deduped: list[str] = []
    seen: set[str] = set()
    for s in species:
        if s not in seen:
            deduped.append(s)
            seen.add(s)
    return deduped


def load_json_mapping(path: Path | None) -> dict[str, str]:
    if path is None:
        return {}
    raw = json.loads(path.read_text(encoding="utf-8"))
    return {normalize_species_name(k): normalize_species_name(v) for k, v in raw.items()}


def try_import_pillow():
    try:
        from PIL import Image  # type: ignore
    except ImportError as exc:
        raise SystemExit(
            "This script requires Pillow.\n"
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


def write_jasc_palette(dest: Path, colors: list[tuple[int, int, int]], dry_run: bool) -> None:
    lines = ["JASC-PAL", "0100", "16"]
    lines.extend(f"{r} {g} {b}" for r, g, b in colors[:16])
    text = "\n".join(lines) + "\n"
    if not dry_run:
        dest.write_text(text, encoding="ascii", newline="\n")


def find_back_sprite(species_dir: Path) -> Path | None:
    for rel in ("male/back.png", "female/back.png"):
        candidate = species_dir / rel
        if candidate.exists():
            return candidate
    return None


def generate_from_shiny_source(
    target_species: str,
    source_species: str,
    shiny_root: Path,
    pp_root: Path,
    overwrite: bool,
    dry_run: bool,
) -> PaletteReport:
    report = PaletteReport(target_species=target_species, source_species=source_species)

    src_dir = shiny_root / source_species
    if not src_dir.exists():
        report.errors.append(f"Missing shiny source folder: {src_dir}")
        return report

    src_back = find_back_sprite(src_dir)
    if src_back is None:
        report.errors.append(f"No shiny back sprite found under: {src_dir}")
        return report

    dest_species_dir = pp_root / target_species
    if not dest_species_dir.exists():
        report.errors.append(f"Missing pokeplatinum species folder: {dest_species_dir}")
        return report

    dest_pal = dest_species_dir / "shiny.pal"
    if dest_pal.exists() and not overwrite:
        report.warnings.append(f"Skipped existing shiny.pal for {target_species}")
        return report

    try:
        colors = extract_palette_colors(src_back)
        write_jasc_palette(dest_pal, colors, dry_run)
        report.wrote_palette = True
    except Exception as exc:  # noqa: BLE001
        report.errors.append(f"Failed to generate shiny.pal from {src_back}: {exc}")

    return report


def copy_from_donor_palette(
    target_species: str,
    donor_species: str,
    pp_root: Path,
    overwrite: bool,
    dry_run: bool,
) -> PaletteReport:
    report = PaletteReport(target_species=target_species, donor_species=donor_species)

    donor_pal = pp_root / donor_species / "shiny.pal"
    target_pal = pp_root / target_species / "shiny.pal"

    if not donor_pal.exists():
        report.errors.append(f"Missing donor shiny.pal: {donor_pal}")
        return report

    if not target_pal.parent.exists():
        report.errors.append(f"Missing pokeplatinum species folder: {target_pal.parent}")
        return report

    if target_pal.exists() and not overwrite:
        report.warnings.append(f"Skipped existing shiny.pal for {target_species}")
        return report

    if not dry_run:
        shutil.copy2(donor_pal, target_pal)
    report.wrote_palette = True
    report.warnings.append(f"Copied shiny.pal from donor species '{donor_species}'")
    return report


def report_payload(reports: list[PaletteReport]) -> list[dict[str, Any]]:
    return [
        {
            "target_species": r.target_species,
            "source_species": r.source_species,
            "donor_species": r.donor_species,
            "ok": r.ok,
            "wrote_palette": r.wrote_palette,
            "warnings": r.warnings,
            "errors": r.errors,
        }
        for r in reports
    ]


def print_summary(reports: list[PaletteReport], dry_run: bool) -> None:
    title = "Dry run shiny palette summary" if dry_run else "Shiny palette summary"
    print(f"\n{title}")
    print("=" * len(title))
    for r in reports:
        status = "OK" if r.ok else "ERROR"
        source = r.source_species or r.donor_species or "none"
        print(f"[{status}] {r.target_species} <- {source}")
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

    source_mapping = load_json_mapping(args.mapping_file)
    palette_mapping = load_json_mapping(args.palette_map)
    reports: list[PaletteReport] = []

    for target_species in species:
        if target_species in palette_mapping:
            donor = palette_mapping[target_species]
            reports.append(
                copy_from_donor_palette(
                    target_species=target_species,
                    donor_species=donor,
                    pp_root=args.pp_root,
                    overwrite=args.overwrite,
                    dry_run=args.dry_run,
                )
            )
            continue

        if args.shiny_root is None:
            reports.append(
                PaletteReport(
                    target_species=target_species,
                    errors=[
                        "No --shiny-root provided and no donor palette mapping matched this species"
                    ],
                )
            )
            continue

        source_species = source_mapping.get(target_species, target_species)
        reports.append(
            generate_from_shiny_source(
                target_species=target_species,
                source_species=source_species,
                shiny_root=args.shiny_root,
                pp_root=args.pp_root,
                overwrite=args.overwrite,
                dry_run=args.dry_run,
            )
        )

    print_summary(reports, args.dry_run)

    if args.report:
        payload = report_payload(reports)
        if not args.dry_run:
            args.report.write_text(json.dumps(payload, indent=2), encoding="utf-8")
        else:
            print(f"\nReport would be written to: {args.report}")

    return 1 if any(not r.ok for r in reports) else 0


if __name__ == "__main__":
    raise SystemExit(main())
