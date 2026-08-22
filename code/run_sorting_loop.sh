#!/bin/bash
# Full-loop validation on a small simulated slice, one `datalad run` per stage.
#
# Three stages, three commits, three artifacts — the point being that a
# sorter change re-runs only stage 2, and a threshold change only stage 3.
# Serial by construction: `datalad run` is not concurrency-safe within a
# dataset (measured: 5 of 8 concurrent invocations fail on index.lock).
set -euo pipefail

# Refuse to run against a datalad that cannot record this sweep correctly.
# Released datalad (<= 1.6.2) loses run records under concurrency and rejects
# nested runs (gh-7899, gh-7900). See .specify/specs/datalad-pin.md.
DATALAD_PIN="30b6deef70e6808de43c40bfe870462de7ae9373"
DATALAD_VERSION="$(datalad --version 2>&1 | awk '{print $NF}')"
case "$DATALAD_VERSION" in
    *"${DATALAD_PIN:0:9}"*) : ;;
    *)
        echo "datalad is $DATALAD_VERSION, but this study needs the #7901 fixes." >&2
        echo "Provenance would be silently wrong: concurrent runs lose records." >&2
        echo "Install with:" >&2
        echo "  uv tool install --force \\" >&2
        echo "    \"datalad @ git+https://github.com/datalad/datalad.git@$DATALAD_PIN\"" >&2
        echo "Or set COMPBENCH_ALLOW_ANY_DATALAD=1 to override (records may be wrong)." >&2
        [ -n "${COMPBENCH_ALLOW_ANY_DATALAD:-}" ] || exit 1
        ;;
esac
STUDY="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$STUDY"
VENV="$STUDY/envs/compbench"
WV=/data/yoh/compression-comparisons/vendor/wavpack
export PATH="$WV/bin:$VENV/bin:$PATH" LD_LIBRARY_PATH="$WV/lib:${LD_LIBRARY_PATH:-}"
export TMPDIR="${TMPDIR:-$STUDY/.tmp}"; mkdir -p "$TMPDIR"

MEAREC=sourcedata/aind-ephys-compression/mearec/mearec_NP1.h5
DUR="${DUR:-30}"; LSB=12
OUT="derivatives/sorting-loop-$(date -I)"

for SPEC in "bittrunc:bits=0" "bittrunc:bits=5"; do
  CODEC="${SPEC%%:*}"; PARAMS="${SPEC#*:}"; CELL="$OUT/${CODEC}-${PARAMS//=/}"
  echo "### $CELL"

  datalad run --explicit --input "$MEAREC" --output "$CELL" \
    -m "compress: $CODEC $PARAMS on ${DUR}s MEArec NP1 (lsb=$LSB)" \
    "compbench compress --mearec $MEAREC --lsb $LSB --duration-s $DUR \
        --codec $CODEC --codec-params $PARAMS --chunk-duration-s 1.0 \
        --output-dir $CELL"

  datalad run --explicit --input "$CELL/compressed.zarr" --output "$CELL" \
    -m "spikesort: kilosort4 on $CELL" \
    "compbench spikesort --zarr $CELL/compressed.zarr --output-dir $CELL"

  datalad run --explicit --input "$CELL/sorting" --input "$MEAREC" --output "$CELL" \
    -m "compare: $CELL vs MEArec ground truth" \
    "compbench compare-sorting --sorting $CELL/sorting --mearec $MEAREC \
        --duration-s $DUR --output-dir $CELL"
done
echo "=== loop complete ==="
