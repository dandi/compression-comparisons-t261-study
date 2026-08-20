# Sweep report (partial)

**Cells:** 20 total (15 lossless + 5 lossy).

One or more cells failed; report contains successful cells only.

| codec | params | CR | enc xRT | dec xRT | RMSE | lossless | wall_s | RSS GB |
| --- | --- | ---: | ---: | ---: | ---: | :---: | ---: | ---: |
| t261 | t261-26ca7af3 | 23.500 | 0.02 | 0.22 | 1.5320 | F | 478.81 | 5.71 |
| t261 | t261-2ab16306 | 16.261 | 0.03 | 0.27 | 1.0002 | F | 377.56 | 5.71 |
| t261 | t261-68e11cda | 12.081 | 0.02 | 0.20 | 0.6743 | F | 496.66 | 5.72 |
| t261 | t261-178c1436 | 9.898 | 0.02 | 0.18 | 0.5064 | F | 560.09 | 5.72 |
| t261 | t261-fbf3bd60 | 8.761 | 0.02 | 0.16 | 0.4055 | F | 577.78 | 5.72 |
| t261 | t261-preset_combinedPresetEEG_IndepChannel_lossless | 6.902 | 0.09 | 0.22 | 0.0000 | T | 175.18 | 3.77 |
| lzma | lzma-preset_6 | 3.361 | 0.04 | 2.75 | 0.0000 | T | 274.80 | 3.77 |
| zstd | zstd-level_22 | 3.129 | 0.03 | 23.88 | 0.0000 | T | 331.41 | 3.77 |
| blosc-zstd | blosc-zstd-level_9-shuffle_byte | 2.803 | 0.48 | 108.08 | 0.0000 | T | 35.25 | 3.77 |
| zstd | zstd-level_3 | 2.734 | 5.86 | 22.84 | 0.0000 | T | 13.90 | 3.77 |
| blosc-zlib | blosc-zlib-level_9-shuffle_byte | 2.632 | 0.22 | 42.38 | 0.0000 | T | 58.99 | 3.77 |
| zlib | zlib-level_5 | 2.604 | 0.95 | 7.72 | 0.0000 | T | 25.04 | 3.77 |
| gzip | gzip-level_5 | 2.604 | 0.76 | 5.64 | 0.0000 | T | 33.18 | 3.77 |
| blosc-zlib | blosc-zlib-level_3-shuffle_byte | 2.442 | 6.87 | 42.19 | 0.0000 | T | 19.60 | 3.77 |
| blosc-zstd | blosc-zstd-level_3-shuffle_byte | 2.377 | 9.79 | 66.62 | 0.0000 | T | 15.79 | 3.77 |
| blosc-lz4hc | blosc-lz4hc-level_9-shuffle_byte | 1.972 | 1.16 | 239.89 | 0.0000 | T | 20.69 | 3.77 |
| blosc-lz4hc | blosc-lz4hc-level_3-shuffle_byte | 1.717 | 9.45 | 231.36 | 0.0000 | T | 13.21 | 3.77 |
| lz4 | lz4-acceleration_1 | 1.662 | 7.49 | 41.23 | 0.0000 | T | 15.67 | 3.77 |
| blosc-lz4 | blosc-lz4-level_9-shuffle_byte | 1.418 | 36.27 | 115.94 | 0.0000 | T | 19.81 | 3.77 |
| blosc-lz4 | blosc-lz4-level_3-shuffle_byte | 1.357 | 36.55 | 120.81 | 0.0000 | T | 14.33 | 3.77 |

## Highlights

- **Best lossless:** `t261` (t261-preset_combinedPresetEEG_IndepChannel_lossless) — CR 6.902.
- **Best lossy CR:** `t261` (t261-26ca7af3) — CR 23.500, RMSE 1.5320.
