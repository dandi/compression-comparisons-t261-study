#!/bin/bash
# Lossy compression -> spike sorting -> ground-truth comparison, one arm per
# codec configuration, driven by a profile YAML.
#
# THE QUESTION THIS ANSWERS. The paper's headline lossy claim is that WavPack
# Hybrid at 2.25 bps "preserves spike waveforms and does not affect sorting
# accuracy". Compression ratio cannot answer whether T.261 can make the
# analogous claim; only sorting accuracy against ground truth can. This is
# that measurement.
#
# THREE STAGES, THREE `datalad run` RECORDS per arm, so a sorter change
# re-runs only stage 2 and a threshold change only stage 3:
#     compress -> compressed.zarr
#     spikesort -> sorting/
#     compare   -> sorting_metrics.json
#
# SERIAL, and not because of datalad. The pinned datalad handles concurrent
# runs correctly (verified: repro/datalad-pr7901-flat-concurrency.sh at
# N=64). Stage 2 is serial because there is one GPU. It is therefore safe to
# run this alongside a CPU compression sweep in the same dataset: every
# commit here carries a run record, which the concurrent cells'
# dirty-committed check accepts.
#
# Resumable: an arm whose stage output already exists is skipped, so this can
# be re-run after an interruption without repeating finished work.
#
# Usage: ./code/run_sorting_sweep.sh [profile-name] [duration-s]
#   e.g. ./code/run_sorting_sweep.sh sorting-eval-t261 100
set -euo pipefail

STUDY="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$STUDY"

# Refuse to run against a datalad that cannot record this correctly.
DATALAD_PIN="30b6deef70e6808de43c40bfe870462de7ae9373"
DATALAD_VERSION="$(datalad --version 2>&1 | awk '{print $NF}')"
case "$DATALAD_VERSION" in
    *"${DATALAD_PIN:0:9}"*) : ;;
    *)
        echo "datalad is $DATALAD_VERSION, but this study needs the #7901 fixes." >&2
        echo "Set COMPBENCH_ALLOW_ANY_DATALAD=1 to override (records may be wrong)." >&2
        [ -n "${COMPBENCH_ALLOW_ANY_DATALAD:-}" ] || exit 1
        ;;
esac

TOOL="$STUDY/code/compression-comparisons-tools"
VENV="${COMPBENCH_VENV:-$STUDY/envs/compbench}"
WV=/data/yoh/compression-comparisons/vendor/wavpack
export PATH="$WV/bin:$VENV/bin:$PATH" LD_LIBRARY_PATH="$WV/lib:${LD_LIBRARY_PATH:-}"
export TMPDIR="${TMPDIR:-$STUDY/.tmp}"; mkdir -p "$TMPDIR"
export COMPBENCH_BLOSC_THREADS="${COMPBENCH_BLOSC_THREADS:-1}"

PROFILE="${1:-sorting-eval-t261}"
DUR="${2:-100}"
LSB=12                      # MEArec NP1 is simulated at Open Ephys scaling
MEAREC=sourcedata/aind-ephys-compression/mearec/mearec_NP1.h5
# Duration is part of the identity of the results, not a detail: a 100 s
# slice and the full 600 s recording give different sorter baselines (the
# paper sorts the whole file and recovers 100/100 units; a 100 s slice
# recovers 87). Without it in the path, a second run at another duration
# lands in the first one's directory and every arm is skipped as done.
OUT="derivatives/sorting-$(date -I)-${PROFILE}-${DUR}s"

# Pinned-checkout guard: the recorded tool commit must be what runs.
PINNED="$(git rev-parse HEAD:code/compression-comparisons-tools)"
ACTUAL="$(git -C "$TOOL" rev-parse HEAD)"
[ "$PINNED" = "$ACTUAL" ] || {
    echo "Tool checkout is $ACTUAL but the study pins $PINNED." >&2; exit 1; }

# The arm list comes from the profile, so it is defined in exactly one place.
mapfile -t ARMS < <("$VENV/bin/python" - "$TOOL/configs/profiles/${PROFILE}.yaml" <<'PY'
import sys
from pathlib import Path
from compbench.pipeline.profile import load_profile, expand_matrix
prof = load_profile(sys.argv[1])
for cell in expand_matrix(prof, generated_dir=Path("/tmp/sorting-gen")):
    # cell_id <TAB> codec <TAB> k=v,k=v
    print(f"{cell.cell_id}\t{cell.codec}\t{cell.codec_params_cli}")
PY
)

echo "=== [$(date -Is)] sorting sweep: $PROFILE ==="
echo "    arms       : ${#ARMS[@]}"
echo "    duration   : ${DUR}s of $MEAREC"
echo "    tool commit: $ACTUAL (pinned)"
echo "    results    : $OUT"
mkdir -p "$OUT"

i=0
for arm in "${ARMS[@]}"; do
    i=$((i + 1))
    IFS=$'\t' read -r cell_id codec params <<< "$arm"
    # cell_id from expand_matrix carries the dataset prefix; the arm is the
    # codec half, which is what distinguishes rows here
    CELL="$OUT/${cell_id##*__}"
    echo "--- [$i/${#ARMS[@]}] $codec ${params:-(defaults)}"

    if [ -f "$CELL/compressed.zarr/.zgroup" ]; then
        echo "      compress: already done"
    else
        datalad run --explicit --input "$MEAREC" --output "$CELL" \
            -m "compress: $codec ${params:-defaults} on ${DUR}s MEArec NP1 (lsb=$LSB)" \
            "compbench compress --mearec $MEAREC --lsb $LSB --duration-s $DUR \
                --codec $codec ${params:+--codec-params $params} \
                --chunk-duration-s 1.0 --output-dir $CELL"
    fi

    if [ -d "$CELL/sorting" ]; then
        echo "      spikesort: already done"
    else
        datalad run --explicit --input "$CELL/compressed.zarr" --output "$CELL" \
            -m "spikesort: kilosort4 on $CELL" \
            "compbench spikesort --zarr $CELL/compressed.zarr --output-dir $CELL"
    fi

    if [ -f "$CELL/sorting_metrics.json" ]; then
        echo "      compare: already done"
    else
        datalad run --explicit --input "$CELL/sorting" --input "$MEAREC" --output "$CELL" \
            -m "compare: $CELL vs MEArec ground truth" \
            "compbench compare-sorting --sorting $CELL/sorting --mearec $MEAREC \
                --duration-s $DUR --output-dir $CELL"
    fi
done
echo "=== [$(date -Is)] sorting sweep complete: $OUT ==="
