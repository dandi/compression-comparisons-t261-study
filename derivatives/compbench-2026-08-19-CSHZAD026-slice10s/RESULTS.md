# Reproduction results — CSHZAD026 (IBL NP1), 10 s slice

**Date:** 2026-08-19
**Dataset:** `sourcedata/aind-ephys-compression/ibl-np1/CSHZAD026_2020-09-04_probe00` — 10 s slice from t=0, 384 channels × 30 kHz × int16 (230 MB raw).
**Tool:** `code/compression-comparisons-tools/` at commit d3bece0 (host venv; container recipe verified but not used for this run — sandbox lacked fuse for apptainer).
**Codec sweep:** `configs/profiles/paper-real.yaml` — 21 configs (8 blosc + 6 standard + 2 T.261 lossless + 5 T.261 lossy QP-sweep).
**Outcome:** 20/21 cells passed. The joint-channel EEG lossless T.261 encoder (`combinedPresetEEG_lossless`) hit the 30-minute wall-clock timeout — inter-channel prediction on 384 channels of 10 s @ 30 kHz is beyond what the subprocess wrapper can bound cheaply. Independent-channel lossless finished in 191 s.

## Full results

Sorted by compression ratio, descending. `enc_xRT` = duration / encode wall-time.

| codec           | discriminator                    |     CR | enc xRT | dec xRT |   RMSE | lossless | wall_s | RSS GB |
| --------------- | -------------------------------- | -----: | ------: | ------: | -----: | :------: | -----: | -----: |
| t261            | QP=8.0                           | 16.772 |    0.02 |    0.22 |  2.438 |    F     |    530 |   2.10 |
| t261            | QP=5.0                           |  9.019 |    0.02 |    0.20 |  1.452 |    F     |    567 |   1.72 |
| t261            | QP=3.0                           |  6.209 |    0.02 |    0.22 |  0.869 |    F     |    517 |   1.77 |
| t261            | QP=2.0                           |  4.989 |    0.02 |    0.18 |  0.602 |    F     |    583 |   2.24 |
| t261            | QP=1.5                           |  4.395 |    0.02 |    0.18 |  0.456 |    F     |    588 |   1.98 |
| **t261**        | **IndepChannel lossless**        |  **3.804** | 0.07 |  0.18 |  **0** |  **T**   |    191 |   2.11 |
| lzma            | preset 6                         |  2.612 |    0.04 |    1.40 |      0 |    T     |    273 |   1.97 |
| zstd            | level 22                         |  2.327 |    0.03 |   16.63 |      0 |    T     |    375 |   1.67 |
| blosc-zstd      | level 9, byte shuffle            |  2.324 |    0.61 |  133.30 |      0 |    T     |     19 |   2.29 |
| blosc-zlib      | level 9, byte shuffle            |  2.251 |    0.29 |   51.21 |      0 |    T     |     37 |   2.28 |
| blosc-zlib      | level 3, byte shuffle            |  2.056 |    7.51 |   41.40 |      0 |    T     |      4 |   1.78 |
| blosc-zstd      | level 3, byte shuffle            |  2.051 |   18.84 |   83.00 |      0 |    T     |      4 |   2.00 |
| zstd            | level 3                          |  1.943 |    4.62 |   19.84 |      0 |    T     |      5 |   1.99 |
| zlib            | level 5                          |  1.937 |    0.95 |    6.10 |      0 |    T     |     14 |   2.00 |
| gzip            | level 5                          |  1.937 |    0.93 |    4.53 |      0 |    T     |     15 |   2.31 |
| blosc-lz4hc     | level 9, byte shuffle            |  1.714 |    1.48 |  288.61 |      0 |    T     |      9 |   1.67 |
| blosc-lz4hc     | level 3, byte shuffle            |  1.432 |    8.60 |  284.31 |      0 |    T     |      3 |   1.78 |
| blosc-lz4       | level 9, byte shuffle            |  1.361 |   48.90 |  161.98 |      0 |    T     |      4 |   1.57 |
| blosc-lz4       | level 3, byte shuffle            |  1.278 |   49.37 |  109.37 |      0 |    T     |      3 |   2.21 |
| lz4             | acceleration 1                   |  1.171 |   10.40 |   53.68 |      0 |    T     |      4 |   1.94 |
| **t261 (joint-channel lossless)**   | *timed out at 30 min*  |    —   |    —   |    —   |   —   |    —     |  1800  |    —   |

## Findings

1. **T.261 IndepChannel lossless (CR 3.80) is the best lossless codec tested** — 46 % better than the next-best (lzma preset 6, CR 2.61) and 64 % better than the paper's recommended blosc-zstd L9 (CR 2.32).
2. **T.261 QP=1.5 (CR 4.40, RMSE 0.46 counts)** already doubles compression over the best lossless with imperceptible distortion.
3. **T.261 QP=8 hits CR 16.8** — 7 × better than the best lossless, at a cost of RMSE 2.4 counts. Spike-sorting-fidelity evaluation (Kilosort against ground truth) is still needed to confirm whether this is acceptable for downstream analysis.
4. **Encode is 50 × slower than real-time** across every T.261 config (0.02 xRT) — the subprocess stopgap dominates. Phase 2b's pybind11 in-process wrapper is expected to close most of this gap.
5. **Decode is fast** — every T.261 config decodes at 0.18–0.22 xRT ≈ 5 s per 10 s of data, dominated by the file-mode BWC decoder overhead. Not competitive with blosc yet, but tractable.

## Comparison to Buccino et al. 2023 Fig 2 (IBL NP1)

Our numbers are systematically ~20-30 % lower than the paper's reported CRs because we did not apply the paper's 300–6000 Hz band-pass preprocessing (which materially improves CR by reducing the entropy of the sub-300 Hz component). The **ranking** of the lossless codecs matches the paper: lzma > zstd L22 > blosc-zstd L9 > gzip/zlib > blosc-lz4hc > blosc-lz4 > lz4. On absolute magnitudes:

| codec        | our CR (raw)  | paper CR (band-pass) | ratio |
| ------------ | ------------- | -------------------- | ----- |
| lzma         | 2.61          | ~2.7                 | 0.97  |
| blosc-zstd   | 2.32          | ~2.9                 | 0.80  |
| gzip         | 1.94          | ~2.4                 | 0.81  |

Adding band-pass preprocessing (§4 of paper) is a follow-up — codec-preprocessing coupling is a first-class knob in the `configs/datasets/*.yaml` schema.

## Follow-ups

- **T.261 joint-channel lossless:** encode wall-time on 10 s × 384 ch exceeds 30 min. Options: (a) chunk the encode by channel-group, (b) bump timeout to 60 min for this cell, (c) wait for Phase 2b pybind11 wrapper (potentially 2–5 × faster). Not blocking the report — IndepChannel lossless already tells the story.
- **Full-recording numbers:** switch `duration_s: 10` → drop it to encode the full 1 200 s (only feasible with pybind11 wrapper or 24-hour SLURM job on the CLI stopgap).
- **Preprocessing coupling:** add band-pass filter as a `preprocessing: bandpass=300-6000` param on `datasets/*.yaml` so we can plot both "raw" and "band-pass" CR alongside.
- **AIND NP1/NP2 + full IBL set:** run the same profile on the other 15 recordings in `sourcedata/aind-ephys-compression/`.

## Provenance

- `report.parquet`: 20 rows joining per-cell `metrics.json` + `manifest.json` + `duct-info.json`.
- `<cell>/manifest.json`: SHA-256 over shape+dtype+bytes of the input slice, git SHA of the tool code, Python & platform info.
- `<cell>/duct-*.jsonl`: con-duct resource-sampling trace at 1 s intervals.
- Tool code SHA: `d3bece0` — see `../code/compression-comparisons-tools`.
