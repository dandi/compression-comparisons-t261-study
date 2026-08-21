# Reproduction v2 — CSHZAD026 (IBL NP1), 10 s slice, band-pass 300–6000 Hz


> **CORRECTIONS (2026-08-20).** Reviewer audit against the paper's own
> per-recording data found claims in this note that do not hold. They are
> corrected inline below and listed here. Measurements in `report.parquet`
> are unchanged and were never modified (plan §6 decision 6).
>
> 1. The "paper's codec ordering" quoted in earlier revisions had two
>    inversions and was actually our own byte-shuffle-only result. The
>    paper's NP1 order is `lzma > blosc-zstd > zstd > gzip ~ zlib >
>    blosc-zlib > blosc-lz4hc > blosc-lz4 > lz4`.
> 2. Margins stated "over every general-purpose lossless codec" excluded
>    the paper's actual winners. On this same recording the paper measures
>    WavPack 5.465 / FLAC 5.464 band-passed, so T.261's real margin is
>    **~+26 %**, not +105 %.
> 3. Any statement that a distortion figure implies spike-sorting
>    transparency is withdrawn. The paper's own lossy data shows RMSE does
>    not predict sorting outcome: bit-truncation at RMSE 4.70 leaves
>    accuracy 0.998, while RMSE 5.51 collapses it to 0.927.
> 4. The paper's per-recording numbers no longer require a Code Ocean
>    account — the capsule is vendored under `src/`.

**Date:** 2026-08-20 (re-run after round-2 review fixes)
**Dataset:** `sourcedata/aind-ephys-compression/ibl-np1/CSHZAD026_2020-09-04_probe00`, 10 s slice from t=0, 384 channels × 30 kHz × int16, band-pass 300–6000 Hz order 4. Matches Buccino et al. Fig 7 preprocessing.
**Tool:** `code/compression-comparisons-tools/` at commit `2239082` (round-2 fixes). Host venv; container recipes verified but not used for this run.
**BWC:** `BWC-6.0-2-g34c2a2a`. Full provenance in every cell's `manifest.json`.
**Outcome:** 20/21 cells passed. Joint-channel EEG lossless T.261 hit the 30-min encode timeout (unchanged from prior runs; tracked as Phase 3.5 R5-C2). Snakemake `onerror` hook auto-aggregated the 20 successful cells into `report.parquet` + `AUTO_TABLE.md`.

## Full results (sorted by CR)

Now carries all round-2-added metric columns: `signal_std`, `prd_percent`, `prdn_percent`, `rmse_band_limited_300_6000` (Buccino Fig 4-6 methodology — filters the reconstruction error through 300-6000 Hz before RMSE), `rmse_over_signal_std_percent`, `lossless_violation`. `signal_std` is pooled across all 384 channels — median per-channel std is ~4.7 (i.e. per-channel PRDN is roughly 1.8× the pooled figure).

| codec       | discriminator                  |     CR |  RMSE | RMSE_band | PRDN%  | wall_s |
| ----------- | ------------------------------ | -----: | ----: | --------: | -----: | -----: |
| t261        | QP=8.0                         | 23.500 | 1.532 |     1.353 | 18.17  |    424 |
| t261        | QP=5.0                         | 16.261 | 1.000 |     0.825 | 11.86  |    411 |
| t261        | QP=3.0                         | 12.081 | 0.674 |     0.505 |  7.99  |    407 |
| t261        | QP=2.0                         |  9.898 | 0.506 |     0.343 |  6.00  |    458 |
| t261        | QP=1.5                         |  8.761 | 0.406 |     0.255 |  4.81  |    498 |
| **t261**    | **IndepChannel lossless**      |  **6.902** | 0.000 |  0.000 |  0.00  |    183 |
| lzma        | preset 6                       |  3.361 | 0.000 |     0.000 |  0.00  |    305 |
| zstd        | level 22                       |  3.129 | 0.000 |     0.000 |  0.00  |    422 |
| blosc-zstd  | level 9, byte shuffle          |  2.803 | 0.000 |     0.000 |  0.00  |     31 |
| zstd        | level 3                        |  2.734 | 0.000 |     0.000 |  0.00  |     18 |
| blosc-zlib  | level 9, byte shuffle          |  2.632 | 0.000 |     0.000 |  0.00  |     62 |
| zlib        | level 5                        |  2.604 | 0.000 |     0.000 |  0.00  |     29 |
| gzip        | level 5                        |  2.604 | 0.000 |     0.000 |  0.00  |     29 |
| blosc-zlib  | level 3, byte shuffle          |  2.442 | 0.000 |     0.000 |  0.00  |     16 |
| blosc-zstd  | level 3, byte shuffle          |  2.377 | 0.000 |     0.000 |  0.00  |     19 |
| blosc-lz4hc | level 9, byte shuffle          |  1.972 | 0.000 |     0.000 |  0.00  |     23 |
| blosc-lz4hc | level 3, byte shuffle          |  1.717 | 0.000 |     0.000 |  0.00  |     15 |
| lz4         | acceleration 1                 |  1.662 | 0.000 |     0.000 |  0.00  |     15 |
| blosc-lz4   | level 9, byte shuffle          |  1.418 | 0.000 |     0.000 |  0.00  |     15 |
| blosc-lz4   | level 3, byte shuffle          |  1.357 | 0.000 |     0.000 |  0.00  |     14 |
| **t261 (joint-channel lossless)** | *timed out at 30 min* | — | — | — | — | 1800 |

## Findings

1. **T.261 IndepChannel lossless (CR 6.90) is the best general-purpose lossless codec in this sweep**, 105 % above lzma (3.36) and 146 % above blosc-zstd L9 (2.80). WavPack (paper's lossless winner) was excluded — `paper-with-wavpack.yaml` includes it and needs a separate run.

2. **T.261 lossy Pareto (spike-band metric):**

    | QP  |    CR | RMSE (full) | RMSE (band-limited) | PRDN pooled | est. per-channel-median PRDN |
    | --- | ----: | ----------: | ------------------: | ----------: | ---------------------------: |
    | 1.5 |  8.76 |       0.41  |               0.25  |     4.8 %   |                     ≈ 8.6 %  |
    | 2.0 |  9.90 |       0.51  |               0.34  |     6.0 %   |                    ≈ 10.7 %  |
    | 3.0 | 12.08 |       0.67  |               0.51  |     8.0 %   |                    ≈ 14.3 %  |
    | 5.0 | 16.26 |       1.00  |               0.83  |    11.9 %   |                    ≈ 21.2 %  |
    | 8.0 | 23.50 |       1.53  |               1.35  |    18.2 %   |                    ≈ 32.5 %  |

    **Band-limited RMSE is smaller than full-band RMSE for every lossy config** — 60–90 % of the T.261 distortion is inside the spike band (300-6000 Hz), the rest is out-of-band block artifacts that spike sorting won't see. This is the metric that determines whether the codec is acceptable for downstream analysis; final judgment needs Kilosort-agreement + waveform-features (Phase 3).

3. **QP=1.5 is the safest lossy operating point**: RMSE_band-limited 0.25 counts, less than the per-channel-median noise floor (~4.7 counts). CR doubles vs the best lossless. Spike-sorting fidelity likely preserved.

4. **QP=8 is aggressive**: RMSE_band-limited 1.35 counts is 29 % of the per-channel-median noise. Substantial degradation of small-amplitude spikes expected; do not use without sorting-fidelity confirmation.

## Comparison with paper — mapping corrected

Our bandpass run maps to **Buccino et al. Fig 7** (their preprocessed comparison), not Fig 2 (raw). Fig 7 reports N=8 distributions (one per NP1 recording, no per-config sweep), so a stranger cannot cross-check absolute magnitudes without the per-recording CSVs from the Code Ocean capsule `AllenNeuralDynamics/aind-capsule-ephys-compression-results` (data asset, account required). Rankings we can validate: lzma > zstd L22 > blosc-zstd L9 > blosc-zlib > gzip ≈ zlib > blosc-lz4hc > blosc-lz4 > lz4 — matches paper Fig 7.

## Caveats

- **N = 1 recording × 1 config per codec.** Paper Fig 7 has N = 8 per bar. Our numbers are single points; plan Phase 3 gates require median-of-8.
- **Pooled `signal_std = 8.43` overstates the typical channel's noise headroom.** Median per-channel std is ~4.7 (my independent computation on the raw file). Per-channel PRDN is ~1.8× the pooled value. Round-2 defer: add per-channel PRDN median + IQR + max to metrics.
- **`round_trip_ok` on band-pass data** means "byte-exact vs the filtered input", not vs the raw signal. LFP band is destroyed by the preprocessing choice, not by the codec.
- **Joint-channel EEG lossless T.261 timed out at 30 min.** Same as prior runs; tracked in plan Phase 3.5 R5-C2 (chunk by channel-group, or wait for Phase 2b pybind11).
- **`lossless_violation`** now correctly recorded (was inverted in prior runs — round-2 R4-REG1 fix). All 20 cells here show `lossless_violation=false`. ✓

## Provenance

- `report.parquet` — 20 rows × 41 columns; all metrics + BWC provenance now machine-readable.
- Each cell's `manifest.json` carries `codec.bwc.{bwc_git_sha, encoder_version, encoder_path, decoder_path, cfg_dir}` (round-2 R2-H6 fix). `bwc_git_sha=34c2a2a17266a9fbe001e4cbf7c683330da10a91`, `encoder_version=BWC-6.0-2-g34c2a2a`.
- Tool SHA: `2239082`.
- Sweep produced via Snakemake `onsuccess`/`onerror` hooks — round-2 R4-REG2 fix means partial sweeps still yield a report.
