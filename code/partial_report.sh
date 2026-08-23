#!/bin/bash
# Live report for a sweep that is still running.
#
# Reads the in-flight results directory and writes everything OUTSIDE it, into
# .partial-reports/ (gitignored). Nothing here touches the sweep's declared
# output, its dataset state, or the pinned tool submodule — a partial report
# must never be able to disturb the measurement it is reporting on.
#
# Safe to run at any time, as often as you like. Idempotent.
#
# Usage: ./code/partial_report.sh [results-dir]   (default: newest sweep dir)
set -euo pipefail

STUDY="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VENV="${COMPBENCH_VENV:-$STUDY/envs/compbench}"
cd "$STUDY"

RESULTS="${1:-$(ls -dt derivatives/compbench-*-paper-real-np1-8-general 2>/dev/null | head -1)}"
[ -n "$RESULTS" ] && [ -d "$RESULTS" ] || { echo "no results dir found" >&2; exit 1; }

OUT="$STUDY/.partial-reports/$(basename "$RESULTS")"
mkdir -p "$OUT"

TOTAL="${COMPBENCH_TOTAL_CELLS:-912}"
DONE=$(find "$RESULTS" -name metrics.json 2>/dev/null | wc -l | tr -d ' ')
FLIGHT=$(pgrep -af '[c]ompbench run' 2>/dev/null | grep -oE '\-\-output-dir [^ ]+' | sort -u | wc -l | tr -d ' ')

"$VENV/bin/compbench" report --results-dir "$RESULTS" --output "$OUT/report.parquet" >/dev/null
"$VENV/bin/compbench" render-report \
    --parquet "$OUT/report.parquet" \
    --output "$OUT/TABLE.md" \
    --title "Sweep in progress — $(basename "$RESULTS")" \
    --source-note "PARTIAL: $DONE of $TOTAL cells complete at $(date -Is). Numbers for completed cells are final; the set is not." >/dev/null

{
  echo "# Sweep in progress — $(basename "$RESULTS")"
  echo
  echo "Generated $(date -Is) · **$DONE / $TOTAL cells** ($((DONE * 100 / TOTAL))%) · $FLIGHT in flight"
  echo
  echo "> Completed cells are final and will not change. Which cells are"
  echo "> present will. Treat every aggregate below as provisional."
  echo
  echo "## Reproduction against Buccino et al. 2023"
  echo
  python3 code/paper_compare.py "$RESULTS" .specify-ref/paper-reference-lossless.csv 2>/dev/null \
    || python3 code/paper_compare.py "$RESULTS" \
         /data/yoh/compression-comparisons/.specify/specs/paper-reference-lossless.csv
  echo
  echo "## Timing so far"
  echo
  python3 - "$RESULTS" <<'PY'
import json, glob, os, statistics, sys, collections
rd = sys.argv[1]
by = collections.defaultdict(list)
tot_w = tot_ov = 0.0
for f in glob.glob(os.path.join(rd, "*", "metrics.json")):
    d = os.path.dirname(f)
    try:
        m = json.load(open(f))
        w = float((json.load(open(d + "/duct-info.json")).get("execution_summary") or {})["wall_clock_time"])
    except Exception:
        continue
    ct = (m.get("encode_time_s") or 0) + (m.get("decode_time_s") or 0)
    by[os.path.basename(d).split("__")[0].rsplit("-", 1)[-1]].append((w, ct))
    tot_w += w; tot_ov += w - ct
if by:
    print("| condition | n | median wall | median codec | overhead |")
    print("| --- | ---: | ---: | ---: | ---: |")
    for c, v in sorted(by.items()):
        w = statistics.median([x[0] for x in v]); ct = statistics.median([x[1] for x in v])
        print(f"| {c} | {len(v)} | {w/60:.0f} m | {ct/60:.0f} m | {100*(w-ct)/w:.0f}% |")
    print(f"\n{100*tot_ov/tot_w:.0f}% of wall time across completed cells is not codec work.")
PY
  echo
  echo "## Full table"
  echo
  cat "$OUT/TABLE.md"
} | python3 code/align_tables.py > "$OUT/PARTIAL.md"

# the pinned tool predates the alignment fix, so align its output too
python3 code/align_tables.py < "$OUT/TABLE.md" > "$OUT/TABLE.md.tmp" \
    && mv "$OUT/TABLE.md.tmp" "$OUT/TABLE.md"

echo "wrote $OUT/PARTIAL.md  ($DONE/$TOTAL cells)"
