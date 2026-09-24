# Full matrix — Buccino et al. 2023 reproduction on 912 cells

Sweep: `derivatives/compbench-2026-08-22-paper-real-np1-8-general/`
(912 cells, `duct_exit_code == 0` for all 912). Profile:
`configs/profiles/paper-real-np1-8-general.yaml` in the tool repo.
Report generated 2026-09-23; nothing in `derivatives/reports-2026-08-29/`
was modified.

This is the study's largest sweep and the first interpretive pass over it.
The four reports in `reports-2026-08-29/` all predate it; in particular the
phase-1 gate there was computed on a **different 72-cell sweep**
(`compbench-2026-08-25-gate-fig2-corrected`, hardcoded at line 41 of
`scripts/make_gate_report.py`). The 72-cell result is re-derived here from
the full matrix as a cross-check — see §1.2 — and it reproduces exactly.

## 0. What is in the matrix, and how cells are paired to the paper

912 = 24 dataset-conditions x 38 codec configurations. The 24 conditions are
**not** a full 8x4 cross: `lsb_correction` is a documented no-op at LSB 1, so
the two LSB conditions are skipped for the four SpikeGLX/IBL recordings.

| site                      | recordings | conditions present          |   cells |
| ------------------------- | ---------: | --------------------------- | ------: |
| IBL (SpikeGLX, LSB 1)     |          4 | `raw`, `bp`                 |     304 |
| AIND (Open Ephys, LSB 12) |          4 | `raw`, `lsb`, `bp`, `lsbbp` |     608 |
| **total**                 |      **8** | 24 dataset-conditions       | **912** |

Of the 912: 744 lossless (`expected_lossless`), 168 lossy (WavPack hybrid at
7 bps targets x 24 conditions). 168 of the lossless cells carry a delta filter.

Pairing rules, all of them load-bearing:

* **Per recording, never against a pooled median.** `benchmark-lossless.csv`
  is per session (6300 rows, 16 sessions); all 8 of our recordings appear in
  it by name. Comparing a single recording against a median over eight
  measures between-recording spread, not reproduction error.
* **Our condition -> the paper's `lsb` column.** IBL `raw` -> `none`;
  AIND `raw` -> `false`; AIND `lsb` -> `true`. The AIND `raw` arm is
  therefore *also* gradeable, against the paper's own uncorrected rows —
  which is why the gate below has 288 cells rather than 192.
* **Our numeric level -> the paper's level word**, from the profile:
  blosc/gzip/zlib/lzma 9, zstd 22, lz4 acceleration 1 -> `high`;
  flac 5, wavpack 2 -> `medium` (the paper's Fig-6 selection for audio codecs).
* **`channel_chunk_size == -1`.** We chunk along time only, so FLAC cells map
  to the paper's ccs=-1 rows, never its ccs=2 rows. This matters: at ccs=2 the
  paper's FLAC is ~22 % better, and joining across it would be a fabricated
  discrepancy.
* **Delta-filtered cells are joined to `benchmark-lossless-delta.csv` only**,
  never to the non-delta table. A delta changes CR by up to +17 %, so the
  wrong baseline manufactures failures.
* **Band-passed cells are joined to `benchmark-lossless-preprocessing.csv`**
  (`preprocessing == bandpass_300-6000`), never to the non-delta table.

The delta and preprocessing reference tables carry no `lsb` column. They are
LSB-corrected: for session 625749, blosc-zstd/high/bit/1s the delta-1d row is
CR 3.076 against an `lsb=true` baseline of 3.151 and an `lsb=false` baseline
of 2.109. Those cells are therefore paired only against our `lsb`/`lsbbp`
(AIND) and `raw`/`bp` (IBL) arms.

## 1. Phase 1 gate on the full matrix

### 1.1 Verdict

**288 cells pair; median deviation 0.017 %, max 5.39 %.**

Gate thresholds are median <= 2 % and max <= 5 %.

* **Median: PASS**, by two orders of magnitude (0.017 % against 2 %).
* **Max: FAIL by one cell.** 283/288 cells are inside 2 % and 287/288
  are inside 5 %. The single cell outside is
  `aind-625749-raw__blosc-zstd-level_9-shuffle_none-chunk1s`: our CR 1.6589
  against the paper's 1.574, **+5.39 %** — i.e. we compress *better* than the
  paper, not worse.

The honest reading is that the gate passes on everything it was written for
and is tripped by a config the 72-cell gate never contained. All five cells
outside 2 % are the same configuration, `blosc-zstd` with **shuffle disabled**:

| cell                                                              | our CR | paper CR | deviation |
| ----------------------------------------------------------------- | -----: | -------: | --------: |
| `aind-625749-raw__blosc-zstd-level_9-shuffle_none-chunk1s`        | 1.6589 |    1.574 |   +5.39 % |
| `aind-634571-raw__blosc-zstd-level_9-shuffle_none-chunk1s`        | 1.6324 |    1.564 |   +4.38 % |
| `aind-634568-raw__blosc-zstd-level_9-shuffle_none-chunk1s`        | 1.6457 |    1.580 |   +4.16 % |
| `aind-634569-raw__blosc-zstd-level_9-shuffle_none-chunk1s`        | 1.6320 |    1.570 |   +3.95 % |
| `ibl-SWC054-probe00-raw__blosc-zstd-level_9-shuffle_none-chunk1s` | 2.0325 |    1.981 |   +2.60 % |

### 1.2 Cross-check: the 72-cell gate, recomputed from this sweep

Restricting the 288 to exactly the existing report's slice — the 9
general-purpose codecs, shuffle `byte`, the paper's LSB condition:

| source                                            |   n | median deviation | max deviation |
| ------------------------------------------------- | --: | ---------------: | ------------: |
| `reports-2026-08-29/phase1-gate.md` (08-25 sweep) |  72 |           0.02 % |        1.16 % |
| same slice of this 08-22 matrix                   |  72 |           0.02 % |        1.16 % |

Two independently executed sweeps, same conditions, agreeing to the printed
precision. The existing gate report's headline number is confirmed, not
contradicted — it is simply computed over 8 % of the available evidence.

### 1.3 Where the deviation lives: it is entirely a zstd-version signature

Signed deviation (ours/paper - 1, %) by codec and shuffle, over all 288:

| codec         | shuffle |   n | median % |  min % |  max % |
| ------------- | ------- | --: | -------: | -----: | -----: |
| `blosc-lz4`   | bit     |  12 |   +0.002 | -0.038 | +0.028 |
| `blosc-lz4`   | byte    |  12 |   +0.012 | -0.017 | +0.037 |
| `blosc-lz4`   | no      |  12 |   +0.004 | -0.036 | +0.045 |
| `blosc-lz4hc` | bit     |  12 |   -0.013 | -0.032 | +0.025 |
| `blosc-lz4hc` | byte    |  12 |   -0.001 | -0.029 | +0.028 |
| `blosc-lz4hc` | no      |  12 |   +0.009 | -0.008 | +0.029 |
| `blosc-zlib`  | bit     |  12 |   -0.012 | -0.555 | +0.036 |
| `blosc-zlib`  | byte    |  12 |   -0.011 | -0.115 | +0.027 |
| `blosc-zlib`  | no      |  12 |   -0.001 | -0.026 | +0.034 |
| `blosc-zstd`  | bit     |  12 |   +0.158 | -0.142 | +0.469 |
| `blosc-zstd`  | byte    |  12 |   +0.006 | -0.089 | +0.710 |
| `blosc-zstd`  | no      |  12 |   +1.792 | -1.055 | +5.395 |
| `flac`        | no      |  12 |   +0.013 | -0.081 | +0.026 |
| `gzip`        | byte    |  12 |   +0.009 | -0.019 | +0.026 |
| `gzip`        | no      |  12 |   +0.002 | -0.021 | +0.024 |
| `lz4`         | byte    |  12 |   -0.007 | -0.029 | +0.045 |
| `lz4`         | no      |  12 |   +0.001 | -0.039 | +0.040 |
| `lzma`        | byte    |  12 |   -0.001 | -0.019 | +0.024 |
| `lzma`        | no      |  12 |   +0.007 | -0.031 | +0.035 |
| `wavpack`     | no      |  12 |   -0.007 | -0.025 | +0.006 |
| `zlib`        | byte    |  12 |   +0.010 | -0.019 | +0.026 |
| `zlib`        | no      |  12 |   +0.002 | -0.021 | +0.024 |
| `zstd`        | byte    |  12 |   +0.173 | -1.163 | +0.483 |
| `zstd`        | no      |  12 |   +0.037 | -1.671 | +0.732 |

Nine of the eleven codecs sit inside +/-0.06 % at every one of their 12 cells.
The two exceptions are `blosc-zstd` and `zstd` — the same compressor, reached
two ways — and only they exceed +/-0.2 %. This is the expected signature of a
different Zstandard library version (this environment: numcodecs 0.15.1,
zarr 2.18.7, numpy 2.5.2; the capsule's environment is from 2022-23). zstd's
level-22 / blosc-level-9 search is not bitstream-stable across releases, and
the effect is largest exactly where the data is least compressible —
uncorrected AIND at no shuffle, CR ~1.6 — because a fixed absolute gain in
matched bytes is a larger relative gain there.

`blosc-zlib` at bit shuffle shows a single -0.55 % cell; everything else in
that family is inside 0.04 %.

### 1.4 Codec ranking: 11/11

Best configuration per codec, median over the 8 recordings in the paper's LSB
condition, ours from our cells and the paper's from its own per-session rows:

|   # | codec         | our shuffle | our median CR | paper shuffle | paper median CR |     dev |
| --: | ------------- | ----------- | ------------: | ------------- | --------------: | ------: |
|   1 | `wavpack`     | no          |        3.5885 | no            |          3.5890 | -0.01 % |
|   2 | `flac`        | no          |        2.9405 | no            |          2.9405 | +0.00 % |
|   3 | `lzma`        | no          |        2.8147 | no            |          2.8150 | -0.01 % |
|   4 | `blosc-zstd`  | bit         |        2.8000 | bit           |          2.7935 | +0.23 % |
|   5 | `zstd`        | no          |        2.5285 | no            |          2.5425 | -0.55 % |
|   6 | `zlib`        | byte        |        2.3614 | byte          |          2.3610 | +0.02 % |
|   7 | `gzip`        | byte        |        2.3614 | byte          |          2.3610 | +0.02 % |
|   8 | `blosc-zlib`  | byte        |        2.3574 | byte          |          2.3575 | -0.01 % |
|   9 | `blosc-lz4hc` | bit         |        2.2655 | bit           |          2.2660 | -0.02 % |
|  10 | `blosc-lz4`   | bit         |        1.9546 | bit           |          1.9545 | +0.01 % |
|  11 | `lz4`         | byte        |        1.4132 | byte          |          1.4130 | +0.01 % |

* ours : wavpack > flac > lzma > blosc-zstd > zstd > zlib > gzip > blosc-zlib > blosc-lz4hc > blosc-lz4 > lz4
* paper: wavpack > flac > lzma > blosc-zstd > zstd > zlib > gzip > blosc-zlib > blosc-lz4hc > blosc-lz4 > lz4
* identical positions: 11/11

The best-shuffle choice also agrees per codec at 11/11. `gzip` and `zlib` are
exactly tied in both (2.3614 ours, 2.3610 paper) — the pair the 72-cell report
had to argue about is here resolved by leaving both at the same rank.

### 1.5 The paper's Fig-6 headline numbers

The four codecs the paper carries into its headline comparison, at its own
selected configuration, median over the same 8 NP1 recordings:

| codec        | config    |   n | our median CR | paper median CR |     dev |
| ------------ | --------- | --: | ------------: | --------------: | ------: |
| `blosc-zstd` | bit/high  |   8 |        2.8000 |          2.7935 | +0.23 % |
| `lzma`       | no/high   |   8 |        2.8147 |          2.8150 | -0.01 % |
| `flac`       | no/medium |   8 |        2.9405 |          2.9405 | +0.00 % |
| `wavpack`    | no/medium |   8 |        3.5885 |          3.5890 | -0.01 % |

FLAC's 2.9405 lands on the paper's ccs=-1 figure of 2.9405 to four decimals.
The profile YAML predicted 2.940 from the paper's table and told us to compare
against that rather than the ccs=2 value of 3.576; that instruction was correct.

## 2. The preprocessing axis

### 2.1 LSB correction reproduces to 0.007 %

Per recording, per configuration, on the 4 AIND recordings (the IBL recordings
are LSB 1, where the correction is a no-op and the paper's driver skips them):

* our LSB gain, median over 96 paired cells: **x1.4517**
* the paper's, over the identically matched 96 configurations: **x1.4517**
  (x1.4394 if its `low`/`medium` rows are pooled in as well)
* **paired deviation: median -0.007 %**; 78/96 cells inside 0.1 % and
  86/96 inside 1 %

By codec (median gain over 4 recordings x that codec's shuffles):

| codec         | shuffle | our gain | paper gain |      dev |
| ------------- | ------- | -------: | ---------: | -------: |
| `blosc-lz4`   | bit     |  x1.2814 |    x1.2818 | -0.027 % |
| `blosc-lz4`   | byte    |  x1.0337 |    x1.0335 | +0.004 % |
| `blosc-lz4`   | no      |  x1.4881 |    x1.4880 | +0.009 % |
| `blosc-lz4hc` | bit     |  x1.3201 |    x1.3200 | -0.002 % |
| `blosc-lz4hc` | byte    |  x1.1224 |    x1.1221 | +0.001 % |
| `blosc-lz4hc` | no      |  x1.6032 |    x1.6033 | +0.017 % |
| `blosc-zlib`  | bit     |  x1.0015 |    x1.0018 | -0.037 % |
| `blosc-zlib`  | byte    |  x1.4251 |    x1.4253 | -0.020 % |
| `blosc-zlib`  | no      |  x1.6393 |    x1.6391 | +0.008 % |
| `blosc-zstd`  | bit     |  x1.4967 |    x1.4933 | +0.208 % |
| `blosc-zstd`  | byte    |  x1.4581 |    x1.4571 | +0.069 % |
| `blosc-zstd`  | no      |  x1.6301 |    x1.7131 | -4.845 % |
| `flac`        | no      |  x1.7466 |    x1.7468 | -0.012 % |
| `gzip`        | byte    |  x1.4259 |    x1.4261 | -0.003 % |
| `gzip`        | no      |  x1.6493 |    x1.6495 | -0.004 % |
| `lz4`         | byte    |  x1.0335 |    x1.0333 | +0.019 % |
| `lz4`         | no      |  x1.4964 |    x1.4960 | +0.025 % |
| `lzma`        | byte    |  x1.4092 |    x1.4089 | -0.007 % |
| `lzma`        | no      |  x1.4112 |    x1.4114 | -0.014 % |
| `wavpack`     | no      |  x1.7933 |    x1.7935 | -0.012 % |
| `zlib`        | byte    |  x1.4259 |    x1.4261 | -0.003 % |
| `zlib`        | no      |  x1.6493 |    x1.6495 | -0.004 % |
| `zstd`        | byte    |  x1.4260 |    x1.4358 | -0.685 % |
| `zstd`        | no      |  x1.5429 |    x1.5727 | -1.610 % |

Every deviation outside 0.1 % is again `zstd`/`blosc-zstd` and nothing else.
The paper's claim that LSB correction is worth roughly a 1.4x CR multiplier on
Open Ephys data — and that it costs nothing, being an exact integer division —
is reproduced, per recording, per codec.

The largest single gain in the matrix is WavPack at x1.793 and FLAC at x1.747;
the smallest are the configurations that were already exploiting byte-level
structure (`lz4`/`blosc-lz4` at byte shuffle, x1.03) and `blosc-zlib` at bit
shuffle (x1.002 — see §4.2).

### 2.2 Band-passing: the direction reproduces, the magnitude is 1.5-3.5 % off

The paper sweeps preprocessing on four codecs only. Absolute CR on band-passed,
LSB-corrected data, paired per recording (8 cells per codec):

| codec        | shuffle |   n | median dev |      min |      max |
| ------------ | ------- | --: | ---------: | -------: | -------: |
| `blosc-zstd` | bit     |   8 |    -1.57 % |  -2.18 % |  -0.86 % |
| `flac`       | no      |   8 |   -32.49 % | -35.15 % | -27.27 % |
| `lzma`       | byte    |   8 |    -2.64 % |  -3.43 % |  -1.28 % |
| `wavpack`    | no      |   8 |    +0.62 % |  +0.13 % |  +0.99 % |

And the *gain* from band-passing (band-passed CR / same-config unfiltered CR),
which is the quantity the paper's Fig 7 actually plots:

| codec        | our gain | paper gain |      dev |
| ------------ | -------: | ---------: | -------: |
| `blosc-zstd` |  x1.1509 |    x1.1678 |  -1.80 % |
| `flac`       |  x1.1970 |    x1.4782 | -18.79 % |
| `lzma`       |  x1.1232 |    x1.1466 |  -2.63 % |
| `wavpack`    |  x1.4800 |    x1.4705 |  +0.62 % |

Read this carefully:

* **WavPack agrees to +0.62 %** on both the absolute CR and the gain.
* **`blosc-zstd` is -1.8 % and `lzma` -2.6 %** on the gain, consistently across
  all 8 recordings (range -3.4 % to -1.1 %). That is 100x the deviation those
  same two codecs show on *unfiltered* data (§1.3: +0.27 % and -0.001 %). The
  extra deviation is therefore in the filtered samples, not in the codecs.
* **FLAC's -18.8 % on the gain is not a result.** The paper's preprocessing
  rows for FLAC are `channel_chunk_size == 2` and there is no ccs=-1
  preprocessing row anywhere in the capsule, so the ratio cannot be formed on
  matched conditions. FLAC's 2-channel pairing gains far more from band-passed
  data than from raw data, and that gain is absent from our time-only chunking
  by construction. **This comparison is unavailable, and the -18.8 % should not
  be quoted as a reproduction discrepancy.**

The 1.5-3.5 % band-pass gap is the largest unexplained systematic in the matrix.
`compbench.preprocessing._bandpass` delegates to
`spikeinterface.preprocessing.bandpass_filter` (order 5, `margin_ms='auto'`,
`dtype=int16`), materialised in 1 s chunks — deliberately matching by calling
SpikeInterface rather than reimplementing it. But we call SpikeInterface
**0.104.8**, and the capsule's `ephys-compression/scripts/` (which would name
its version and its exact filter arguments) is *not vendored into this repo* —
only the results capsule is. So the residual is consistent with a SpikeInterface
version difference in filter form, margin handling or the round-then-cast, and
**I cannot close it from the material available here.** It does not affect any
unfiltered result, which is every number in §1 and §2.1.

### 2.3 Band-passing *without* LSB correction is worthless on AIND

This axis has no paper counterpart — the capsule has no uncorrected
preprocessing rows — but it is the most practically useful thing in the matrix,
and it is a genuine interaction, not an artefact.

| arm                  | baseline       | median CR gain from band-passing | cells that got *worse* |
| -------------------- | -------------- | -------------------------------: | ---------------------: |
| AIND `bp` / `raw`    | uncorrected    |                          x1.0026 |                  46/96 |
| AIND `lsbbp` / `lsb` | LSB-corrected  |                          x1.0744 |                   5/96 |
| IBL `bp` / `raw`     | native (LSB 1) |                          x1.2121 |                   3/96 |

On uncorrected AIND data band-passing buys nothing at all (median x1.003) and
makes **half the configurations worse**; `lzma`/no loses 16 %, `blosc-zstd`/bit
loses 8 %. On the same recordings after LSB correction it reliably gains ~7 %.

The mechanism is straightforward and worth stating because it is a trap for
anyone preprocessing an Open Ephys archive: at LSB 12 every raw sample is a
multiple of 12, which is a large, cheap, purely structural redundancy that
byte/bit shuffling plus an entropy coder exploits very effectively. The filter
output is not a multiple of anything. So on uncorrected data band-passing
*destroys* more redundancy than the spectral flattening creates. Correct the
LSB first — which costs nothing and is exact — and the two effects compose
(x1.451 then x1.074).

The one codec that is indifferent is WavPack (x1.69 on uncorrected AIND,
x1.48 on corrected): its predictive model does not depend on the quantisation
lattice the way a shuffle-plus-entropy-coder pipeline does.

### 2.4 Delta filters (paper Fig 7a) — reproduced

56 of our 168 delta cells fall in the paper's condition and all 56 pair:

| codec        | delta         |   n | our CR | paper CR |     dev | our gain | paper gain |
| ------------ | ------------- | --: | -----: | -------: | ------: | -------: | ---------: |
| `blosc-zstd` | 1d            |   8 | 2.7225 |   2.7125 | +0.37 % |  x0.9755 |    x0.9756 |
| `blosc-zstd` | 2d-space      |   8 | 2.7227 |   2.7125 | +0.37 % |  x0.9757 |    x0.9758 |
| `blosc-zstd` | 2d-time       |   8 | 3.2499 |   3.2365 | +0.41 % |  x1.1690 |    x1.1670 |
| `blosc-zstd` | 2d-time-space |   8 | 3.1078 |   3.0980 | +0.32 % |  x1.1276 |    x1.1253 |
| `lzma`       | 2d-time       |   8 | 2.8071 |   2.8070 | +0.00 % |  x1.0967 |    x1.0968 |
| `flac`       | 2d-time       |   8 | 3.5216 |   3.5385 | -0.48 % |  x1.2011 |    x0.9929 |
| `wavpack`    | 2d-time       |   8 | 3.5649 |   3.5650 | -0.00 % |  x0.9958 |    x0.9956 |

The paper's headline delta result — `blosc-zstd` NP1 2.79 -> 3.24 with a
2d-time delta — comes out as 2.800 -> 3.250 here, a x1.169 gain against the
paper's x1.167. 1d and 2d-space *cost* ~2.4 % in both. `wavpack` is unmoved
(x0.996 vs x0.996), `lzma` gains ~9.7 % in both.

The FLAC row deserves a note that is a finding rather than a caveat: our
delta'd FLAC CR is 3.5216 against the paper's 3.5385, **-0.48 %**, even though
the paper's row is ccs=2 and ours is ccs=-1 — the configuration mismatch that
is worth -32 % on band-passed data in §2.2. A 2d-time delta removes the
inter-channel correlation that FLAC's 2-channel stereo pairing exists to
exploit, so the two chunkings converge. That is a consistency check passing
from an unexpected direction, and it is also why this join looks clean while
the §2.2 one does not.

## 3. The 168 lossy cells

All 168 are WavPack **hybrid** at bps in {2.25, 2.5, 3.0, 3.5, 4.0, 5.0, 6.0},
across all 24 dataset-conditions. There are no lossy FLAC cells in this sweep:
the profile runs FLAC only in its lossless mode (`level: 5`, plus one
`delta_2d-time` variant). **The brief's expectation of "wavpack hybrid at
various bps, flac" is half right — the FLAC half does not exist here.**

The paper's comparable table is `results-lossy-exp/benchmark-lossy-exp.csv`,
`strategy == wavpack`. It covers **4** of our 8 NP1 recordings (625749, 634568,
CSHZAD026, SWC054_probe00), at 8 factors including 0.0 = lossless. That its
`factor == 0.0` CR for 625749 is 3.59, matching the `lsb=true`/medium/1s row of
the main table exactly, confirms it is LSB-corrected, unfiltered, 1 s — so it
pairs with our `lsb` (AIND) and `raw` (IBL) arms. 32 cells pair.

|  bps |   n | CR dev (median) |     min |     max | our median RMSE | paper median RMSE | RMSE dev (median, paired) |
| ---: | --: | --------------: | ------: | ------: | --------------: | ----------------: | ------------------------: |
|    0 |   4 |         -0.07 % | -0.39 % | +0.03 % |          0.0000 |            0.0000 |        n/a (paper RMSE 0) |
| 2.25 |   4 |         +0.55 % | +0.42 % | +0.70 % |          1.9868 |            2.5545 |             -14.7 % (n=4) |
|  2.5 |   4 |         -2.87 % | -5.65 % | +0.17 % |          1.5876 |            2.3905 |             -32.8 % (n=4) |
|    3 |   4 |         +1.99 % | +0.97 % | +4.89 % |          1.1388 |            1.5950 |             -27.6 % (n=4) |
|  3.5 |   4 |         +0.05 % | -1.00 % | +0.41 % |          0.9721 |            1.3765 |             -29.6 % (n=4) |
|    4 |   4 |         +2.98 % | +1.44 % | +7.47 % |          0.8426 |            1.2275 |             -32.6 % (n=4) |
|    5 |   4 |         +5.03 % | -0.22 % | +6.29 % |          0.3379 |            0.3370 |              +2.4 % (n=4) |
|    6 |   4 |         +1.87 % | +0.13 % | +3.17 % |          0.0042 |            0.0000 |             +26.7 % (n=1) |

### 3.1 The lossless point reproduces; the hybrid points do not

At `factor == 0` the four paired cells land within **0.4 %** of the paper
(-0.39 % to +0.03 %). Everything above 0 is a different codec.

At nominally the same bps target our CR is within about +/-7 % but our RMSE is
**systematically 25-35 % lower**, at every bps from 2.25 to 4.0, on all four
recordings, without a single exception. The correct way to state that is as a
rate-distortion comparison — our RMSE against the paper's own curve
interpolated at *our* CR:

|  bps |   n | our RMSE vs paper's curve at our CR |     min |     max |
| ---: | --: | ----------------------------------: | ------: | ------: |
| 2.25 |   4 |                             -14.7 % | -32.8 % | -11.5 % |
|  2.5 |   4 |                             -26.5 % | -36.4 % | -23.5 % |
|    3 |   4 |                             -32.3 % | -33.7 % | -27.9 % |
|  3.5 |   4 |                             -29.6 % | -38.4 % | -27.9 % |
|    4 |   4 |                             -35.5 % | -36.6 % | -33.5 % |
|    5 |   4 |                              +6.0 % | -49.6 % | +35.3 % |
|    6 |   4 |                             +11.1 % | -90.9 % | +87.6 % |

Median over bps 2.25-4.0: **-31.0 %**. Our operating curve is strictly
inside the paper's over the whole useful range. The bps 5.0 and 6.0 rows are
not interpretable — the paper's RMSE there is 0.000-0.383 and rounded to three
decimals, so the ratio is dominated by rounding.

The cause is recorded in the profile and should be taken at face value:
`wavpack-numcodecs` **0.2.3** (this environment) changed the hybrid-mode flag
from `=` to `|=` relative to the **0.1.3** the paper used, so at a given bps we
emit a different bitstream. This is not a reproduction failure to be fixed by
re-running; it is a real, documented difference in the tool under test.

**The consequence for the rest of the study is the important part.** The paper's
WavPack-hybrid curve is the baseline T.261 is measured against (paper Fig 10-14,
and `reports-2026-08-29/t261-vs-paper-compression.md`). Any such comparison run
on *these* cells is against a WavPack that is ~30 % better in RMSE at matched
CR than the one in the paper. T.261 results framed as "beats/ties the paper's
WavPack" must say which WavPack, and the honest comparator is ours, not the
paper's published numbers.

### 3.2 The hybrid sweep is degenerate at high bps on band-passed data

12 of the 168 lossy cells round-trip **bit-exactly** (`rmse == 0.0`,
`round_trip_ok == True` on a cell declared lossy):

| recording            | condition | bps |     CR |
| -------------------- | --------- | --: | -----: |
| `aind-625749`        | lsbbp     |   5 | 5.2834 |
| `aind-625749`        | lsbbp     |   6 | 5.2834 |
| `aind-634568`        | lsbbp     |   5 | 5.3558 |
| `aind-634568`        | lsbbp     |   6 | 5.3558 |
| `aind-634569`        | lsbbp     |   5 | 5.3506 |
| `aind-634569`        | lsbbp     |   6 | 5.3506 |
| `aind-634571`        | lsbbp     |   5 | 5.2150 |
| `aind-634571`        | lsbbp     |   6 | 5.2150 |
| `ibl-CSHZAD026`      | bp        |   6 | 5.4700 |
| `ibl-SWC054-probe00` | bp        |   6 | 4.8399 |
| `ibl-SWC054-probe01` | bp        |   5 | 5.3926 |
| `ibl-SWC054-probe01` | bp        |   6 | 5.3926 |

Every one is band-passed (`bp` or `lsbbp`) at bps 5.0 or 6.0, and in each case
the CR equals the same cell's lossless CR to 4-6 digits: for
`aind-625749-lsbbp`, bps 6.0 and bps 5.0 both give 5.28339 against a lossless
5.28524. Band-passing removes enough dynamic range that a 5-6 bps target
exceeds what lossless coding already costs, and the hybrid encoder falls back.
Several more cells are near-degenerate rather than exactly so
(`ibl-CSHZAD029-bp` at bps 5.0: RMSE 0.0072, CR 5.2687 vs 5.2697 at bps 6.0).

**There are effectively no usable lossy operating points above ~4.0 bps on
band-passed data.** A rate-distortion curve drawn through them is a curve
through one point repeated, and a T.261-vs-WavPack comparison in that regime
compares against lossless WavPack under a lossy label.

CR is monotone non-increasing in bps in all 24 conditions, with zero
violations. The apparent oddity that 18 cells at bps 6.0 have CR slightly
*below* their own lossless CR is correct behaviour, not a bug: hybrid mode
writes a correction stream, and that overhead is real even when the
approximation is exact.

### 3.3 Distortion is not comparable across the preprocessing axis

Raw RMSE is not comparable across the LSB axis. On 625749 at bps 2.25 the
`raw` arm reports 25.28 and the `lsb` arm 2.13 — a 12x difference that is
entirely the LSB-12 scale factor, not 12x the damage.

Normalising by each condition's own signal standard deviation
(`rmse_over_signal_std_percent`, median over the recordings in that arm)
**reverses the ordering**, which is the part worth knowing:

| site | condition |  2.25 |   2.5 |     3 |  3.5 |    4 |    5 |    6 |
| ---- | --------- | ----: | ----: | ----: | ---: | ---: | ---: | ---: |
| AIND | raw       | 19.93 | 14.65 |  9.77 | 6.73 | 4.56 | 2.33 | 1.24 |
| AIND | lsb       | 20.67 | 16.25 | 11.80 | 9.82 | 8.56 | 3.67 | 0.00 |
| AIND | bp        |  8.26 |  4.88 |  2.47 | 1.55 | 1.07 | 0.51 | 0.02 |
| AIND | lsbbp     | 11.96 | 11.24 |  8.93 | 5.68 | 1.33 | 0.00 | 0.00 |
| IBL  | raw       | 11.03 |  8.81 |  5.90 | 4.82 | 3.97 | 1.83 | 0.26 |
| IBL  | bp        | 10.45 |  9.36 |  7.05 | 4.93 | 1.48 | 0.02 | 0.00 |

(RMSE as a percentage of that arm's own signal standard deviation)

At a fixed bps target the LSB-corrected arm takes **more** relative damage
than the uncorrected one — 8.6 % against 4.6 % at bps 4.0, and the gap widens
with bps — because correction
has already removed the free structural redundancy and the encoder has to
find the remaining bits somewhere. Band-passing moves it the other way. The
cells are therefore four distinct rate-distortion regimes, and mixing them
into one curve — which a naive group-by on `bps` alone would do — is wrong.

## 4. Anomalies

### 4.1 No lossless failure anywhere

All 744 cells declared lossless have `rmse == 0.0`, `round_trip_ok == True`
and `lossless_violation == False`. All 156 `round_trip_ok == False` cells are
lossy WavPack cells with `expected_lossless == False`; the other 12 lossy cells
are the degenerate ones in §3.2. There is no cell in the matrix where a codec
promised losslessness and did not deliver it.

### 4.2 `blosc-zlib` at bit shuffle is pathological — and the paper agrees exactly

| shuffle | our median CR | paper median CR |      dev |
| ------- | ------------: | --------------: | -------: |
| bit     |        1.2962 |          1.2965 | -0.026 % |
| byte    |        2.3574 |          2.3575 | -0.006 % |
| no      |        2.1631 |          2.1630 | +0.003 % |

`blosc-zlib` is the only codec whose *best* shuffle is `byte` rather than `bit`,
and at `bit` it loses 45 % of its CR — landing at 1.296, below the best
configuration of every other codec in the matrix including `lz4`'s 1.4132. It
is the only one where LSB correction is worth nothing (x1.0015, against
x1.03-1.79 everywhere else), and the only configuration anywhere in the matrix
where band-passing makes IBL data *worse* (x0.896 median; 3 of its 4 IBL
recordings lose CR, and they are 3 of the only 3 such cells out of 96).

Three of those behaviours are present in the paper's own data to
three decimals — see the table above and the x1.0018 LSB gain in §2.1 — so
this is a reproduced property of blosc+zlib, not a defect in our runner. The
fourth cannot be checked: the paper sweeps preprocessing on four codecs only
and `blosc-zlib` is not among them.

It is worth flagging loudly nonetheless, because a reader skimming the matrix for
"bit shuffle is best" will get this one wrong.

### 4.3 Two configurations fail to compress at all, as they do in the paper

| codec       | shuffle | our median CR | our min | paper median CR | paper min |
| ----------- | ------- | ------------: | ------: | --------------: | --------: |
| `blosc-lz4` | no      |        1.0000 |  1.0000 |          1.0000 |    1.0000 |
| `lz4`       | no      |        0.9997 |  0.9994 |          1.0000 |    0.9990 |
| `lz4`       | byte    |        1.4155 |  1.3907 |          1.4155 |    1.3910 |

On uncorrected AIND data `blosc-lz4` with shuffle off returns CR 1.0000 — blosc
detects the incompressible block and stores it — and bare `lz4` returns 0.9997,
i.e. the output is *larger* than the input. The paper's own numbers are 1.0000
and 0.9990. Reproduced, including the sign.

### 4.4 No codec disagrees with its own family

`gzip` and `zlib` agree to a maximum relative difference of 1.4e-06 across all
48 of their cells — both are DEFLATE at level 9, the container differs and the
payload does not — matching the paper's own `gzip == zlib`. `blosc-lz4` <
`blosc-lz4hc` and `lz4` < `blosc-lz4` hold in every condition.

The one ordering worth pointing at is `zstd` at level **22** (best CR 2.5285)
losing to `blosc-zstd` at level **9** (2.8000). That is not a family
disagreement: blosc applies a bit shuffle zstd alone cannot, and the shuffle is
worth more than 13 levels of search. The paper has the identical ordering
(2.5425 vs 2.7935), so it reproduces.

### 4.5 Timings are not comparable and are not used above

For completeness, ours against the capsule's, median over the 288 gate cells:

| codec         | our encode xRT | paper encode xRT | ratio | our decode xRT | paper decode xRT | ratio |
| ------------- | -------------: | ---------------: | ----: | -------------: | ---------------: | ----: |
| `blosc-lz4`   |         22.835 |           14.531 |  1.78 |          7.641 |           50.000 |  0.15 |
| `blosc-lz4hc` |          0.937 |            8.373 |  0.10 |          5.072 |           50.000 |  0.12 |
| `blosc-zlib`  |          0.173 |            2.308 |  0.07 |          3.695 |           20.000 |  0.19 |
| `blosc-zstd`  |          0.172 |            2.698 |  0.08 |          5.018 |           50.000 |  0.11 |
| `flac`        |          4.216 |           31.121 |  0.13 |          6.361 |            6.250 |  1.08 |
| `gzip`        |          0.102 |            2.555 |  0.03 |          5.349 |            4.348 |  1.19 |
| `lz4`         |         21.174 |           17.121 |  0.99 |         10.525 |           14.286 |  0.70 |
| `lzma`        |          0.058 |            0.863 |  0.07 |          1.574 |            0.980 |  1.59 |
| `wavpack`     |          2.633 |           13.386 |  0.20 |          2.244 |           11.806 |  0.20 |
| `zlib`        |          0.101 |            2.648 |  0.04 |          3.974 |            4.348 |  0.88 |
| `zstd`        |          0.060 |            1.059 |  0.06 |          6.161 |            3.775 |  2.01 |

Our encode throughput is a median 0.08x the capsule's and decode 0.51x, with
per-codec ratios spanning 0.03x to 2.0x. This is **not** a finding: blosc is
pinned to a single thread in this study (`codec_blosc_nthreads == 1` in every
manifest) while the capsule's is not, the hosts differ, and the paper's figures
are rounded to values like exactly 50.0 xRT. No speed claim in this report
depends on these numbers, and none should be made from them without a
same-host measurement.

## 5. What could not be compared, and why

| question                                | status                | reason                                                                                                                             |
| --------------------------------------- | --------------------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| Lossy FLAC vs paper                     | **not in this sweep** | the profile runs FLAC lossless only; there are no lossy FLAC cells to compare                                                      |
| FLAC band-pass gain                     | **unavailable**       | the paper's preprocessing FLAC rows are `channel_chunk_size=2` and no ccs=-1 counterpart exists in the capsule                     |
| Lossy wavpack on the other 4 recordings | **no reference**      | `benchmark-lossy-exp.csv` covers only 4 of our 8 NP1 sessions                                                                      |
| Lossy wavpack on band-passed data       | **no reference**      | the paper ran lossy on unfiltered, LSB-corrected data only                                                                         |
| Band-passing without LSB correction     | **no reference**      | the capsule has no uncorrected preprocessing rows (§2.3 is ours alone)                                                             |
| Source of the 1.5-3.5 % band-pass gap   | **open**              | `ephys-compression/scripts/` is not vendored here, so the paper's SpikeInterface version and exact filter arguments are unknown    |
| Bit shuffle for non-blosc codecs        | **does not exist**    | bit shuffle is a blosc feature; the reference has no `bit` rows for gzip/zlib/lz4/zstd/lzma, and its absence is not a failed join  |
| Chunk-size axis                         | **not swept**         | this profile fixes 1 s, on the paper's own finding that chunk size does not move CR (its Fig 1 row 2; ratio 1.0000 at 10 s vs 1 s) |

## 6. Summary of verdicts

| claim under test                                     |             n cells | result                                                                                                                                   |
| ---------------------------------------------------- | ------------------: | ---------------------------------------------------------------------------------------------------------------------------------------- |
| Lossless CR reproduces per recording (median <= 2 %) |                 288 | **PASS** — 0.017 %                                                                                                                       |
| Lossless CR reproduces per recording (max <= 5 %)    |                 288 | **FAIL by one cell** — 5.39 %, `blosc-zstd`/no-shuffle, in our favour                                                                    |
| ... restricted to the existing gate's slice          |                  72 | **PASS** — 0.02 % / 1.16 %, matching `reports-2026-08-29/phase1-gate.md`                                                                 |
| Codec ranking reproduces                             |           11 codecs | **PASS** — 11/11 positions, 11/11 best-shuffle choices                                                                                   |
| LSB correction gain reproduces                       |                  96 | **PASS** — paired median deviation -0.007 %                                                                                              |
| Band-pass gain reproduces                            | 24 (+8 unavailable) | **QUALIFIED** — direction and ordering yes, magnitude 1.5-3.5 % low for `blosc-zstd`/`lzma`, exact for `wavpack`, unavailable for `flac` |
| Delta-filter gain reproduces                         |                  56 | **PASS** — all within 0.5 %, including the 2.79->3.24 headline                                                                           |
| Lossless WavPack reproduces                          |                   4 | **PASS** — within 0.4 %                                                                                                                  |
| WavPack *hybrid* rate-distortion reproduces          |                  28 | **FAIL, explained** — our RMSE is ~31 % lower at matched CR (bps 2.25-4.0); `wavpack-numcodecs` 0.2.3 vs the paper's 0.1.3               |
| Any lossless cell silently lossy                     |                 744 | **none**                                                                                                                                 |

## 7. Reproducing the numbers in this report

```
cd results/dandi-t261-compression-study
./envs/compbench/bin/python   # has pandas/numpy
>>> import pandas as pd
>>> d = pd.read_parquet('derivatives/compbench-2026-08-22-paper-real-np1-8-general/report.parquet')
```

Reference CSVs are in the **tool** repo, not checked out under the study:
`src/capsule-ephys-compression-results/data/ephys-compression-results/`
(`results-lossless/benchmark-lossless{,-delta,-preprocessing}.csv`,
`results-lossy-exp/benchmark-lossy-exp.csv`).

Two warnings for whoever automates this next:

* `code/paper_compare.py` in the study **does not work on this data**. It
  expects an aggregated CSV with `cr_min`/`cr_max`/`cr_median` columns and
  fails soft, printing "No completed lossless cells join a paper row yet"
  rather than raising. Do not read its silence as a result.
* `scripts/make_gate_report.py` hardcodes
  `derivatives/compbench-2026-08-25-gate-fig2-corrected` at line 41 and
  filters the reference to `level == 'high'`, which excludes FLAC and WavPack
  entirely. It cannot produce §1 of this report without both being changed.
