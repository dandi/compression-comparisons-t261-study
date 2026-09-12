#!/usr/bin/env python3
"""Join completed sweep cells to the Buccino et al. 2023 reference table.

Lives in the STUDY's code/, not in the pinned tool submodule: the submodule's
state must not change while a sweep is running, and this is a monitoring aid
rather than part of the measurement. When the sweep is done and the finding
is settled, it belongs in `compbench report` proper.

Mapping to the paper's rows:
  * IBL recordings have lsb=1, where `correct_lsb` is documented to be a
    no-op, so IBL `raw` sits in the paper's `corrected` pool (n=8).
  * AIND `raw` is `uncorrected` (n=4); AIND `lsb` is `corrected`.
  * `bp` / `lsbbp` are excluded: they belong to the paper's pre-processing
    figure, which has its own reference numbers, not this lossless table.
"""
from __future__ import annotations

import csv
import glob
import json
import os
import re
import statistics
import sys

# the paper publishes 3-4 decimals; a value landing on a range endpoint is a
# match, not a miss
EPS = 5e-4
SHUFFLE = {"bit": "bit", "byte": "byte", "none": "no", "no": "no"}


def load_reference(path):
    lines = [l for l in open(path) if not l.startswith("#")]
    ref = {}
    for r in csv.DictReader(lines):
        if r["probe"] != "NP1" or r["chunk_duration"] != "1s":
            continue
        # first row wins; later duplicates are channel_chunk_size variants
        ref.setdefault(
            (r["compressor"], r["level"], r["shuffle"], r["lsb_mode"]), r)
    return ref


def rows_for(results_dir, ref, skipped_delta=None):
    out = []
    if skipped_delta is None:
        skipped_delta = []
    for f in sorted(glob.glob(os.path.join(results_dir, "*", "metrics.json"))):
        cell = os.path.basename(os.path.dirname(f))
        if "__" not in cell:
            continue
        ds, codecpart = cell.split("__", 1)
        cond = ds.rsplit("-", 1)[-1]
        if cond not in ("raw", "lsb"):
            continue
        lsb_mode = "corrected" if (ds.startswith("ibl") or cond == "lsb") else "uncorrected"
        # A delta-filtered cell must NOT be joined to the non-delta table: the
        # filter changes the CR, so the comparison would be against the wrong
        # reference. The capsule keeps a separate benchmark-lossless-delta.csv
        # for these. Counted and skipped rather than silently mis-joined --
        # 14 of 22 apparent "outside range" cells were this bug.
        if "-delta_" in codecpart:
            skipped_delta.append(cell)
            continue
        m = re.match(r"(.+?)-(?:level|preset|acceleration)_([0-9.]+)(?:-shuffle_(\w+))?", codecpart)
        if not m:
            continue
        codec, lvl, shuf = m.group(1), m.group(2), m.group(3)
        level = "high" if lvl in ("9", "22", "1") else "medium"
        r = ref.get((codec, level, SHUFFLE.get(shuf, shuf), lsb_mode))
        if not r:
            continue
        try:
            cr = json.load(open(f))["cr"]
        except Exception:
            continue
        lo, hi, med = float(r["cr_min"]), float(r["cr_max"]), float(r["cr_median"])
        out.append({
            "cell": cell, "cr": cr, "median": med, "lo": lo, "hi": hi,
            "in_range": (lo - EPS) <= cr <= (hi + EPS),
            "on_edge": abs(cr - lo) < EPS or abs(cr - hi) < EPS,
        })
    return out


def main():
    results_dir, ref_csv = sys.argv[1], sys.argv[2]
    skipped_delta = []
    rows = rows_for(results_dir, load_reference(ref_csv), skipped_delta)
    if not rows:
        print("No completed lossless cells join a paper row yet.")
        return
    inr = sum(r["in_range"] for r in rows)
    edge = sum(r["on_edge"] for r in rows)
    dev = [abs(r["cr"] - r["median"]) / r["median"] for r in rows]
    if skipped_delta:
        print(f"*{len(skipped_delta)} delta-filtered cells excluded: they need "
              f"`benchmark-lossless-delta.csv`, not the non-delta reference.*\n")
    print(f"**{inr}/{len(rows)}** joined cells fall inside the paper's "
          f"per-recording CR range ({100 * inr / len(rows):.0f}%). "
          f"{edge} land exactly on a range endpoint — that recording is the "
          f"extreme in the paper's own set.\n")
    print(f"Deviation from the paper's *pooled* median (over 8 recordings): "
          f"median {100 * statistics.median(dev):.1f}%, max {100 * max(dev):.1f}%. "
          f"Per-recording spread is expected against a pooled median; the "
          f"in-range result is the meaningful one until the paired "
          f"per-recording comparison can run on the finished sweep.\n")
    miss = [r for r in rows if not r["in_range"]]
    if miss:
        print(f"### Outside the paper's range ({len(miss)})\n")
        print("| cell | ours | paper median | paper range |")
        print("| --- | ---: | ---: | --- |")
        for r in sorted(miss, key=lambda r: -abs(r["cr"] - r["median"]) / r["median"]):
            print(f"| `{r['cell']}` | {r['cr']:.3f} | {r['median']:.3f} "
                  f"| [{r['lo']:.3f}, {r['hi']:.3f}] |")
    else:
        print("No cell is outside the paper's range.")


if __name__ == "__main__":
    main()
