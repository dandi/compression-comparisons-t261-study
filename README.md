# dandi-t261-compression-study

STAMPED-style research object: reproduction of Buccino et al. 2023,
"Compression strategies for large-scale electrophysiology data"
([J Neural Eng 20 056009](https://doi.org/10.1088/1741-2552/acf5a4)), plus a
comparison against the newly-standardised **ITU-T T.261 / ISO/IEC 23003-8**
("H.BWC") codec.

## Status (2026-09-30)

**The reproduction is complete and it passes.** 912 cells, 0 errors.

| claim                                    | n cells | result                                                |
| ---------------------------------------- | ------: | ----------------------------------------------------- |
| Lossless CR reproduces, median deviation |     288 | **PASS** — 0.017 % (threshold 2 %)                    |
| Lossless CR reproduces, max deviation    |     288 | one cell over — 5.39 % (threshold 5 %), in our favour |
| Codec ranking reproduces                 |      11 | **PASS** — 11/11, and 11/11 best-shuffle              |
| LSB-correction gain reproduces           |      96 | **PASS** — −0.007 %                                   |
| Delta-filter gain reproduces             |      56 | **PASS** — within 0.5 %                               |
| Any lossless cell silently lossy         |     744 | **none**                                              |

Comparison is paired **per recording** against the capsule's own per-session
numbers, not against its pooled medians — the pooled surrogate made the
reproduction look ~250x worse than it is.

**T.261 versus WavPack Hybrid is a trade, not a winner.** WavPack 2.25 bps:
CR 7.10, +5 excess false-positive units. T.261 QP 5.0: CR 8.58, +19. Both at
lossless-parity unit recovery. T.261 compresses ~21 % harder; WavPack keeps
the detector quieter.

### Three caveats that travel with every lossy number here

* **False positives are not resolvable at one run per arm.** The error bar
  from WavPack's own scatter is ~17 units; the headline difference above is
  14. Two subsequent changes that were rate-neutral or *improved* fidelity
  moved FP by +15 and +22.
* **A T.261 defect is present in every result so far.** 1 s is not a whole
  number of 1024-sample blocks, and BWC pads the remainder by repeating the
  last sample; that block codes at 2.46x the body's RMSE, peaking at 3.6x QP,
  on 54 % of channels — roughly 600 bursts per 600 s recording.
  `--chunk-duration-s 1.024` removes it for −0.096 % CR. It does **not**
  reduce false positives (it raised them), so it is a fidelity fix.
* **The Fig-14 verdict at 600 s is unresolved.** T.261 QP 5.0 passes the
  paper's 10 % waveform line at 100 s (p90 0.085) and fails at 600 s (0.120).
  If the 600 s figure holds, T.261 has no operating point that both passes
  the tolerance and beats WavPack's rate ceiling.

## Layout

- `code/compression-comparisons-tools/` — the compbench toolkit, pinned as a
  submodule (`dandi/compression-comparisons`). The pinned commit is what
  produced the numbers; `code/run_sweep.sh` refuses to start otherwise.
- `code/run_sweep.sh`, `code/run_sorting_sweep.sh` — the entry points. Use
  these rather than invoking Snakemake directly: they run the *pinned* tool
  from a non-editable venv, so editing the development checkout mid-sweep
  cannot change the code producing later cells.
- `envs/compbench/` — the study's own venv. Deliberately outside the
  submodule, which must not move while compute is running.
- `sourcedata/aind-ephys-compression/` — the AIND benchmark data (subdataset
  of `///aind-benchmark-data/ephys-compression`, 523 GB, 16 recordings).
- `derivatives/compbench-*/` — compression sweeps. One directory per cell with
  `metrics.json`, `manifest.json` and `duct-*` resource profiles, plus a
  `report.parquet` and rendered `AUTO_TABLE.md`.
- `derivatives/sorting-*/` — sorting sweeps: `compressed.zarr`,
  `sorter_output/`, `sorting/`, `sorting-metrics.json` per arm.
- `derivatives/reports-*/` — the interpretive reports. Start with the
  `README.md` in each; `reports-2026-09-23/full-matrix.md` analyses the
  completed 912-cell sweep.

## Provenance

Every one of the 912 cells carries its own `[DATALAD RUNCMD]` commit recording
the tool commit, input hashes and command line.

Two known gaps, both recorded rather than papered over: this sweep has **no
sweep-level run record** (earlier sweeps have one; the outer `datalad run`
staged its aggregates and exited without committing them), and 20 cells were
lost across three incidents before the cause was found — see below.

**Requires a patched datalad.** Released datalad (<= 1.6.2) loses run records
under concurrency and rejects nested runs (gh-7899, gh-7900). `run_sweep.sh`
refuses to run without the pinned build and explains how to install it;
`COMPBENCH_ALLOW_ANY_DATALAD=1` overrides, and records may then be wrong.

**Do not commit to this dataset while a sweep is in flight.** A commit on this
branch lands inside some cell's `datalad run` window; that cell fails with
"command created commits that include files not declared as --output" and
Snakemake then deletes its *completed* outputs. This has cost finished compute
three times. A pre-commit guard refuses such commits; write to
`.partial-reports/` (gitignored) or to the tool repo instead.

A related trap, now fixed in the tool: `datalad run --explicit --output <dir>`
refuses a declared output directory that exists but is untracked, which is
exactly what a failed cell leaves behind — so every re-run failed on the
previous run's debris rather than on the original cause, and 10 cells were
permanently stuck until the debris was moved aside.

## Reproducing

```bash
# 1. Clone with subdatasets
datalad clone <this-repo-url> study && cd study
datalad get code/compression-comparisons-tools
datalad get sourcedata/aind-ephys-compression/ibl-np1/CSHZAD026_2020-09-04_probe00

# 2. Build the environment (needs the PINNED tool commit checked out first)
uv venv envs/compbench
uv pip install --python envs/compbench/bin/python \
    './code/compression-comparisons-tools[ephys,pipeline,sorting]' \
    wavpack-numcodecs flac-numcodecs
cmake -S code/compression-comparisons-tools/src/bwc \
      -B code/compression-comparisons-tools/src/bwc/build \
      -DCMAKE_CXX_FLAGS="-Wno-restrict"
cmake --build code/compression-comparisons-tools/src/bwc/build -j

# 3. Run a sweep — this wraps it in `datalad run` and records provenance
./code/run_sweep.sh paper-real-np1-8-general --cores 10

# Resume an existing sweep in place instead of starting a new dated one:
COMPBENCH_RESULTS_DIR=derivatives/compbench-2026-08-22-paper-real-np1-8-general \
    ./code/run_sweep.sh paper-real-np1-8-general --cores 10

# 4. Sorting evaluation (needs a GPU for Kilosort 4)
./code/run_sorting_sweep.sh sorting-eval-t261 600
```

The environment must be installed *after* checking out the tool commit you
intend to run: the install is non-editable, so the venv holds a copy. A stale
venv silently runs different code than the commit the dataset records — which
happened once and is what the `run_sweep.sh` pin guard now catches.
