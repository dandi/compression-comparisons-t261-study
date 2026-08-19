# Auto-rendered table — CSHZAD026 slice10s

**Cells:** 20 total (15 lossless + 5 lossy).

Rendered from report.parquet via compbench render-report. Runs after any new cells are added and re-run through 'compbench report' + 'compbench render-report'.

| codec | params | CR | enc xRT | dec xRT | RMSE | lossless | wall_s | RSS GB |
| --- | --- | ---: | ---: | ---: | ---: | :---: | ---: | ---: |
| t261 | t261-26ca7af3 | 16.772 | 0.02 | 0.22 | 2.4380 | F | 529.51 | 2.10 |
| t261 | t261-2ab16306 | 9.019 | 0.02 | 0.20 | 1.4516 | F | 566.55 | 1.72 |
| t261 | t261-68e11cda | 6.209 | 0.02 | 0.22 | 0.8687 | F | 517.03 | 1.77 |
| t261 | t261-178c1436 | 4.989 | 0.02 | 0.18 | 0.6017 | F | 583.40 | 2.24 |
| t261 | t261-fbf3bd60 | 4.395 | 0.02 | 0.18 | 0.4563 | F | 587.64 | 1.98 |
| t261 | t261-preset_combinedPresetEEG_IndepChannel_lossless | 3.804 | 0.07 | 0.18 | 0.0000 | T | 191.50 | 2.11 |
| lzma | lzma-preset_6 | 2.612 | 0.04 | 1.40 | 0.0000 | T | 273.11 | 1.97 |
| zstd | zstd-level_22 | 2.327 | 0.03 | 16.63 | 0.0000 | T | 375.45 | 1.67 |
| blosc-zstd | blosc-zstd-level_9-shuffle_byte | 2.324 | 0.61 | 133.30 | 0.0000 | T | 18.88 | 2.29 |
| blosc-zlib | blosc-zlib-level_9-shuffle_byte | 2.251 | 0.29 | 51.21 | 0.0000 | T | 36.89 | 2.28 |
| blosc-zlib | blosc-zlib-level_3-shuffle_byte | 2.056 | 7.51 | 41.40 | 0.0000 | T | 4.01 | 1.78 |
| blosc-zstd | blosc-zstd-level_3-shuffle_byte | 2.051 | 18.84 | 83.00 | 0.0000 | T | 3.68 | 2.00 |
| zstd | zstd-level_3 | 1.943 | 4.62 | 19.84 | 0.0000 | T | 4.74 | 1.99 |
| zlib | zlib-level_5 | 1.937 | 0.95 | 6.10 | 0.0000 | T | 14.38 | 2.00 |
| gzip | gzip-level_5 | 1.937 | 0.93 | 4.53 | 0.0000 | T | 15.42 | 2.31 |
| blosc-lz4hc | blosc-lz4hc-level_9-shuffle_byte | 1.714 | 1.48 | 288.61 | 0.0000 | T | 9.10 | 1.67 |
| blosc-lz4hc | blosc-lz4hc-level_3-shuffle_byte | 1.432 | 8.60 | 284.31 | 0.0000 | T | 3.46 | 1.78 |
| blosc-lz4 | blosc-lz4-level_9-shuffle_byte | 1.361 | 48.90 | 161.98 | 0.0000 | T | 3.63 | 1.57 |
| blosc-lz4 | blosc-lz4-level_3-shuffle_byte | 1.278 | 49.37 | 109.37 | 0.0000 | T | 2.84 | 2.21 |
| lz4 | lz4-acceleration_1 | 1.171 | 10.40 | 53.68 | 0.0000 | T | 3.52 | 1.94 |

## Highlights

- **Best lossless:** `t261` (t261-preset_combinedPresetEEG_IndepChannel_lossless) — CR 3.804.
- **Best lossy CR:** `t261` (t261-26ca7af3) — CR 16.772, RMSE 2.4380.
