# Band-pass 300-6000 Hz — CSHZAD026 slice10s

**Cells:** 20 total (15 lossless + 5 lossy).

20/21 cells (joint-channel EEG lossless T.261 timed out at 30 min). Preprocessing: bandpass, low=300, high=6000, order=4.

| codec | params | CR | enc xRT | dec xRT | RMSE | lossless | wall_s | RSS GB |
| --- | --- | ---: | ---: | ---: | ---: | :---: | ---: | ---: |
| t261 | t261-26ca7af3 | 23.500 | 0.03 | 0.20 | 1.5320 | F | 423.80 | 3.77 |
| t261 | t261-2ab16306 | 16.261 | 0.03 | 0.21 | 1.0002 | F | 410.73 | 3.77 |
| t261 | t261-68e11cda | 12.081 | 0.03 | 0.24 | 0.6743 | F | 406.78 | 3.77 |
| t261 | t261-178c1436 | 9.898 | 0.03 | 0.19 | 0.5064 | F | 457.81 | 3.77 |
| t261 | t261-fbf3bd60 | 8.761 | 0.02 | 0.18 | 0.4055 | F | 497.66 | 3.77 |
| t261 | t261-preset_combinedPresetEEG_IndepChannel_lossless | 6.902 | 0.08 | 0.21 | 0.0000 | T | 183.45 | 3.77 |
| lzma | lzma-preset_6 | 3.361 | 0.04 | 2.28 | 0.0000 | T | 305.40 | 3.77 |
| zstd | zstd-level_22 | 3.129 | 0.02 | 20.26 | 0.0000 | T | 421.72 | 3.77 |
| blosc-zstd | blosc-zstd-level_9-shuffle_byte | 2.803 | 0.59 | 119.49 | 0.0000 | T | 31.39 | 3.77 |
| zstd | zstd-level_3 | 2.734 | 4.63 | 19.26 | 0.0000 | T | 17.68 | 3.77 |
| blosc-zlib | blosc-zlib-level_9-shuffle_byte | 2.632 | 0.21 | 44.33 | 0.0000 | T | 61.90 | 3.77 |
| zlib | zlib-level_5 | 2.604 | 0.79 | 6.51 | 0.0000 | T | 28.75 | 3.77 |
| gzip | gzip-level_5 | 2.604 | 0.80 | 5.41 | 0.0000 | T | 29.06 | 3.77 |
| blosc-zlib | blosc-zlib-level_3-shuffle_byte | 2.442 | 7.31 | 41.77 | 0.0000 | T | 15.62 | 3.77 |
| blosc-zstd | blosc-zstd-level_3-shuffle_byte | 2.377 | 14.47 | 97.49 | 0.0000 | T | 19.19 | 3.77 |
| blosc-lz4hc | blosc-lz4hc-level_9-shuffle_byte | 1.972 | 1.06 | 252.78 | 0.0000 | T | 23.39 | 3.77 |
| blosc-lz4hc | blosc-lz4hc-level_3-shuffle_byte | 1.717 | 8.65 | 189.77 | 0.0000 | T | 15.34 | 3.77 |
| lz4 | lz4-acceleration_1 | 1.662 | 9.32 | 52.96 | 0.0000 | T | 15.26 | 3.77 |
| blosc-lz4 | blosc-lz4-level_9-shuffle_byte | 1.418 | 42.74 | 131.43 | 0.0000 | T | 15.09 | 3.77 |
| blosc-lz4 | blosc-lz4-level_3-shuffle_byte | 1.357 | 57.00 | 180.53 | 0.0000 | T | 14.05 | 3.77 |

## Highlights

- **Best lossless:** `t261` (t261-preset_combinedPresetEEG_IndepChannel_lossless) — CR 6.902.
- **Best lossy CR:** `t261` (t261-26ca7af3) — CR 23.500, RMSE 1.5320.
