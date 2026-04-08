#!/usr/bin/env python3

import argparse
import json
from pathlib import Path


def load_messages(path: Path):
    with path.open("r", encoding="utf-8") as f:
        return json.load(f)["messages"]


def format_description(entry):
    text = entry["en_US"]
    if isinstance(text, list):
        return "".join(text).rstrip("\n")
    return str(text)


def main():
    parser = argparse.ArgumentParser(
        description="Preview move names and description text without rebuilding the ROM."
    )
    parser.add_argument(
        "--move",
        help="Show only moves whose names contain this text (case-insensitive).",
    )
    parser.add_argument(
        "--index",
        type=int,
        help="Show only the move at this numeric index.",
    )
    args = parser.parse_args()

    repo_root = Path(__file__).resolve().parents[2]
    move_names = load_messages(repo_root / "res" / "text" / "move_names.json")
    move_descs = load_messages(repo_root / "res" / "text" / "move_descriptions.json")

    if len(move_names) != len(move_descs):
        raise SystemExit(
            f"move_names.json has {len(move_names)} entries but "
            f"move_descriptions.json has {len(move_descs)} entries."
        )

    query = args.move.lower() if args.move else None
    found = 0

    for index, (name_entry, desc_entry) in enumerate(zip(move_names, move_descs)):
        move_name = name_entry["en_US"]

        if args.index is not None and index != args.index:
            continue

        if query is not None and query not in move_name.lower():
            continue

        found += 1
        print(f"[{index:03}] {move_name}")
        print(format_description(desc_entry))
        print()

    if found == 0:
        raise SystemExit("No matching moves found.")


if __name__ == "__main__":
    main()
