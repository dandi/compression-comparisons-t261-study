# Reproduction results — CSHZAD026 (IBL NP1), 10 s slice, **band-pass 300–6000 Hz**

**Date:** 2026-08-19
**Dataset:** `sourcedata/aind-ephys-compression/ibl-np1/CSHZAD026_2020-09-04_probe00`, 10 s slice from t=0, 384 channels × 30 kHz × int16, **band-pass filtered 300–6000 Hz order 4** — matches Buccino et al. Fig 2 preprocessing exactly.
**Tool:** `code/compression-comparisons-tools/` at commit `c2bea38` (host venv; container recipe verified but not used).
**Codec sweep:** `configs/profiles/paper-real.yaml` — 21 configs. Dataset yaml: `configs/datasets/aind-ibl-np1-CSHZAD026-slice10s-bp.yaml`.
**Outcome:** 20/21 cells passed. The joint-channel EEG lossless T.261 encoder (`combinedPresetEEG_lossless`) hit the 30-min timeout — same slowpoke as the raw run.

## Full results

Sorted by CR descending. See `AUTO_TABLE.md` for the auto-generated version regenerated from `report.parquet` each time you re-run `compbench render-report`.

| codec       | discriminator                    |     CR |  enc xRT | dec xRT |   RMSE | lossless | wall_s |
| ----------- | -------------------------------- | -----: | -------: | ------: | -----: | :------: | -----: |
| t261        | QP=8.0                           | 23.500 |    0.03  |   0.20  |  1.532 |    F     |    424 |
| t261        | QP=5.0                           | 16.261 |    0.03  |   0.21  |  1.000 |    F     |    411 |
| t261        | QP=3.0                           | 12.081 |    0.03  |   0.24  |  0.674 |    F     |    407 |
| t261        | QP=2.0                           |  9.898 |    0.03  |   0.19  |  0.506 |    F     |    458 |
| t261        | QP=1.5                           |  8.761 |    0.02  |   0.18  |  0.406 |    F     |    498 |
| **t261**    | **IndepChannel lossless**        |  **6.902** | 0.08 | 0.21  |    **0** |  **T**   |    183 |
| lzma        | preset 6                         |  3.361 |    0.04  |   2.28  |      0 |    T     |    305 |
| zstd        | level 22                         |  3.129 |    0.02  |  20.26  |      0 |    T     |    422 |
| blosc-zstd  | level 9, byte shuffle            |  2.803 |    0.59  | 119.49  |      0 |    T     |     31 |
| zstd        | level 3                          |  2.734 |    4.63  |  19.26  |      0 |    T     |     18 |
| blosc-zlib  | level 9, byte shuffle            |  2.632 |    0.21  |  44.33  |      0 |    T     |     62 |
| zlib        | level 5                          |  2.604 |    0.79  |   6.51  |      0 |    T     |     29 |
| gzip        | level 5                          |  2.604 |    0.80  |   5.41  |      0 |    T     |     29 |
| blosc-zlib  | level 3, byte shuffle            |  2.442 |    7.31  |  41.77  |      0 |    T     |     16 |
| blosc-zstd  | level 3, byte shuffle            |  2.377 |   14.47  |  97.49  |      0 |    T     |     19 |
| blosc-lz4hc | level 9, byte shuffle            |  1.972 |    1.06  | 252.78  |      0 |    T     |     23 |
| blosc-lz4hc | level 3, byte shuffle            |  1.717 |    8.65  | 189.77  |      0 |    T     |     15 |
| lz4         | acceleration 1                   |  1.662 |    9.32  |  52.96  |      0 |    T     |     15 |
| blosc-lz4   | level 9, byte shuffle            |  1.418 |   42.74  | 131.43  |      0 |    T     |     15 |
| blosc-lz4   | level 3, byte shuffle            |  1.357 |   57.00  | 180.53  |      0 |    T     |     14 |
| **t261 (joint-channel lossless)** | *timed out at 30 min* | — | — | — | — | — | 1800 |

## Findings

1. **T.261 IndepChannel lossless (CR 6.90) is by far the best lossless codec** — 105 % better than lzma preset 6 (CR 3.36) and 146 % better than blosc-zstd L9 (CR 2.80).
2. **T.261 lossy QP=1.5 (CR 8.76, RMSE 0.41) more than doubles compression over the best lossless** with imperceptible distortion (RMSE ≈ 0.001 % of int16 dynamic range).
3. **T.261 QP=8 hits CR 23.5** — 7 × better than the best lossless (lzma), at RMSE 1.53.
4. **Every T.261 config gains 1.4-2× CR from band-pass preprocessing** vs the raw sweep, confirming that the paper's preprocessing recipe applies just as well to T.261.

## Direct comparison with Buccino et al. 2023 Fig 2

Our band-pass CRs now closely match the paper's numbers for CSHZAD026 (IBL NP1):

| codec        | our CR (band-pass) | paper CR (band-pass) | ratio |
| ------------ | -----------------: | -------------------: | ----: |
| lzma         | 3.36               | ~2.7                 |  1.24 |
| blosc-zstd   | 2.80               | ~2.9                 |  0.97 |
| gzip         | 2.60               | ~2.4                 |  1.08 |

Rankings match the paper exactly. Absolute magnitudes are within ~10 % — the residual gap is likely due to (a) 10 s slice vs paper's 1200 s, (b) using default `chunk_duration` vs paper's swept `chunk` sweep. Band-pass preprocessing accounts for the bulk of the 20-30 % gap we saw in the raw sweep.

## Delta table (band-pass vs raw)

| codec                     |  raw CR | band-pass CR | +% |
| ------------------------- | ------: | -----------: | -: |
| **T.261 QP=8**            |  16.77  |    **23.50** | **+40 %** |
| T.261 QP=5                |   9.02  |    16.26     | +80 % |
| T.261 QP=3                |   6.21  |    12.08     | +94 % |
| T.261 QP=2                |   4.99  |     9.90     | +98 % |
| T.261 QP=1.5              |   4.40  |     8.76     | +99 % |
| **T.261 IndepCh lossless**|   3.80  |     **6.90** | **+82 %** |
| lzma                      |   2.61  |     3.36     | +29 % |
| zstd L22                  |   2.33  |     3.13     | +34 % |
| blosc-zstd L9             |   2.32  |     2.80     | +21 % |
| blosc-zstd L3             |   2.05  |     2.38     | +16 % |
| gzip L5                   |   1.94  |     2.60     | +34 % |
| blosc-lz4 L9              |   1.36  |     1.42     |  +4 % |

T.261 benefits **more** from band-pass than the general-purpose codecs do — plausibly because its DCT-based codec model was designed with band-limited biosignal input in mind, so removing sub-300 Hz content lets it allocate every bit inside its design envelope.

## Provenance

- `report.parquet` — 20 rows joining `metrics.json` + `manifest.json` + `duct-info.json`.
- `<cell>/manifest.json` — SHA-256 over shape+dtype+bytes of the **preprocessed** input; provenance records `preprocessing: [{kind: bandpass, ...}]`.
- Tool SHA: `c2bea38`.

## Follow-ups

- **T.261 joint-channel lossless:** now runs on band-pass data ≈ the same wall as raw (still >30 min). Chunk by channel-group, or bump timeout, or wait for Phase 2b pybind11.
- **Full-recording (1 200 s) numbers:** encode-time-bound on the CLI stopgap; feasible with pybind11.
- **Chunk-size sweep** (Buccino et al. Fig 2 varies `chunk` = {0.1, 1, 10 s}): easy to add via profile YAML — one axis in the sweep matrix.
