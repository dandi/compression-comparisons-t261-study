#!/bin/bash
# STAMPED execution — run a sweep from the study's OWN pinned tool checkout.
#
# WHY THIS EXISTS
# ---------------
# Sweeps were being launched against the development checkout via an
# editable install, which meant two things at once:
#
#   * every `compbench run` subprocess imported the live working tree, so an
#     edit made while a sweep was in flight silently changed the code
#     producing later cells (this happened once already, mid-sweep);
#   * the study recorded one tool commit in its gitlink while a different,
#     newer one produced the numbers.
#
# This script runs `code/compression-comparisons-tools` at the commit the
# study has pinned, from a NON-EDITABLE venv inside it. The code is copied
# into site-packages, so the development checkout can be edited freely
# while a sweep runs and cannot affect it.
#
# Usage:  ./run_sweep.sh <profile-name> [snakemake args...]
#   e.g.  ./code/run_sweep.sh paper-real-np1-8-general --cores 10
set -euo pipefail

STUDY="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TOOL="$STUDY/code/compression-comparisons-tools"
# The environment lives in the STUDY, not inside the pinned submodule: the
# submodule is a checkout whose state must not move while compute is
# running, and an environment sitting inside it invites exactly that. Keep
# them separate so the submodule can be treated as read-only during a sweep.
VENV="${COMPBENCH_VENV:-$STUDY/envs/compbench}"
# Transitional: the first STAMPED sweep was launched with the environment
# inside the submodule. Fall back to it so a running sweep is never
# disturbed by relocating its own interpreter.
[ -x "$VENV/bin/compbench" ] || VENV="$TOOL/.venv"
PROFILE_NAME="${1:?usage: run_sweep.sh <profile-name> [snakemake args...]}"
shift || true

[ -x "$VENV/bin/compbench" ] || {
    echo "No environment at $VENV. Create it with:" >&2
    echo "  cd $STUDY && uv venv envs/compbench" >&2
    echo "  uv pip install --python envs/compbench/bin/python \\" >&2
    echo "      './code/compression-comparisons-tools[ephys,pipeline]' \\" >&2
    echo "      wavpack-numcodecs flac-numcodecs" >&2
    echo "" >&2
    echo "Update the submodule to the commit you intend to run FIRST, then install." >&2
    exit 1
}

# Refuse to run against a dirty or unpinned tool checkout — the whole point
# is that the recorded commit is what ran.
PINNED="$(git -C "$STUDY" rev-parse HEAD:code/compression-comparisons-tools)"
ACTUAL="$(git -C "$TOOL" rev-parse HEAD)"
if [ "$PINNED" != "$ACTUAL" ]; then
    echo "Tool checkout is at $ACTUAL but the study pins $PINNED." >&2
    echo "Run: git -C code/compression-comparisons-tools checkout --detach $PINNED" >&2
    exit 1
fi
if [ -n "$(git -C "$TOOL" status --porcelain --untracked-files=no)" ]; then
    echo "Tool checkout has uncommitted changes; results would not be reproducible." >&2
    git -C "$TOOL" status --short --untracked-files=no >&2
    exit 1
fi

# WavPack/FLAC need a system libwavpack on PATH (see the tool repo's .env).
WAVPACK="$TOOL/vendor/wavpack"
[ -d "$WAVPACK" ] || WAVPACK="/data/yoh/compression-comparisons/vendor/wavpack"
export PATH="$WAVPACK/bin:$VENV/bin:$PATH"
export LD_LIBRARY_PATH="$WAVPACK/lib:${LD_LIBRARY_PATH:-}"
export TMPDIR="${TMPDIR:-$STUDY/.tmp}"
export COMPBENCH_BLOSC_THREADS="${COMPBENCH_BLOSC_THREADS:-1}"
mkdir -p "$TMPDIR"

OUT="derivatives/compbench-$(date -I)-${PROFILE_NAME}"
echo "=== [$(date -Is)] $PROFILE_NAME ==="
echo "    tool commit : $ACTUAL (pinned)"
echo "    codecs      : $(compbench list-codecs | tr '\n' ' ')"
echo "    results_dir : $OUT"
echo "    TMPDIR      : $TMPDIR"
cd "$STUDY"

# ---------------------------------------------------------------------------
# Provenance: ONE `datalad run` wrapping the whole sweep.
#
# Not one per cell. Measured: eight concurrent `datalad run` invocations in a
# single dataset produce five failures out of eight (git index.lock
# contention, exit 128), three run records, and five outputs left untracked.
# `datalad run` is not concurrency-safe within a dataset, and a sweep is
# hundreds of cells wide.
#
# One record wrapping a parallel snakemake gives a clean commit with the
# command, inputs and outputs — verified. Per-cell provenance is not lost: it
# lives in each cell's manifest.json (tool SHA, BWC SHA, codec params and
# filters, input sha256, git-annex key of the source recording).
#
# `--explicit` so an unrelated dirty file elsewhere in the study does not
# block a sweep, and so only the declared outputs are saved.
# ---------------------------------------------------------------------------
CMD="snakemake -s code/compression-comparisons-tools/src/compbench/pipeline/Snakefile \
    --configfile code/compression-comparisons-tools/configs/profiles/${PROFILE_NAME}.yaml \
    --config results_dir=$OUT --nocolor $*"

if [ "${COMPBENCH_NO_DATALAD:-0}" = "1" ]; then
    echo "    provenance  : DISABLED (COMPBENCH_NO_DATALAD=1)"
    eval "$CMD"
else
    echo "    provenance  : datalad run --explicit"
    datalad run --explicit \
        --input sourcedata/aind-ephys-compression \
        --output "$OUT" \
        -m "sweep: ${PROFILE_NAME} (tool ${ACTUAL:0:8}, $*)" \
        "$CMD"
fi
echo "=== [$(date -Is)] done (rc=$?) ==="
