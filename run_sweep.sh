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
#   e.g.  ./run_sweep.sh paper-real-np1-8-general --cores 10
set -euo pipefail

STUDY="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TOOL="$STUDY/code/compression-comparisons-tools"
VENV="$TOOL/.venv"
PROFILE_NAME="${1:?usage: run_sweep.sh <profile-name> [snakemake args...]}"
shift || true

[ -x "$VENV/bin/compbench" ] || {
    echo "No frozen venv at $VENV. Create it with:" >&2
    echo "  cd $TOOL && uv venv && uv pip install --python .venv/bin/python '.[ephys,pipeline]' \\" >&2
    echo "      wavpack-numcodecs flac-numcodecs   # NOT -e: the install must be frozen" >&2
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
echo "    tool commit : $ACTUAL (pinned, frozen install)"
echo "    codecs      : $(compbench list-codecs | tr '\n' ' ')"
echo "    results_dir : $OUT"
echo "    TMPDIR      : $TMPDIR"
cd "$STUDY"
snakemake -s "$TOOL/src/compbench/pipeline/Snakefile" \
    --configfile "$TOOL/configs/profiles/${PROFILE_NAME}.yaml" \
    --config results_dir="$OUT" \
    --nocolor "$@"
echo "=== [$(date -Is)] done (rc=$?) ==="
