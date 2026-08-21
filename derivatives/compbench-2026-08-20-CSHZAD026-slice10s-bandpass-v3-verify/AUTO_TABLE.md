# Sweep report (partial)

**Cells:** 20 total (15 lossless + 5 lossy).

One or more cells failed; report contains successful cells only.

| dataset | preproc | codec | params | CR | enc xRT | dec xRT | RMSE | RMSE_bp | PRDN/ch % | lossless | wall_s | RSS GB |
| --- | --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | :---: | ---: | ---: |
| aind-ibl-np1-CSHZAD026-slice10 | bandpass(300-6000Hz,o4) | t261 | t261-26ca7af3 | 23.500 | 0.03 | 0.21 | 1.5320 | 1.3526 | 32.23 | F | 448.65 | 3.98 |
| aind-ibl-np1-CSHZAD026-slice10 | bandpass(300-6000Hz,o4) | t261 | t261-2ab16306 | 16.261 | 0.03 | 0.20 | 1.0002 | 0.8250 | 21.13 | F | 461.88 | 3.98 |
| aind-ibl-np1-CSHZAD026-slice10 | bandpass(300-6000Hz,o4) | t261 | t261-68e11cda | 12.081 | 0.03 | 0.20 | 0.6743 | 0.5054 | 14.24 | F | 462.37 | 3.98 |
| aind-ibl-np1-CSHZAD026-slice10 | bandpass(300-6000Hz,o4) | t261 | t261-178c1436 | 9.898 | 0.03 | 0.20 | 0.5064 | 0.3426 | 10.70 | F | 509.15 | 3.98 |
| aind-ibl-np1-CSHZAD026-slice10 | bandpass(300-6000Hz,o4) | t261 | t261-fbf3bd60 | 8.761 | 0.03 | 0.20 | 0.4055 | 0.2545 | 8.57 | F | 527.26 | 3.98 |
| aind-ibl-np1-CSHZAD026-slice10 | bandpass(300-6000Hz,o4) | t261 | t261-preset_combinedPresetEEG_IndepChannel_lossless | 6.902 | 0.10 | 0.20 | 0.0000 | 0.0000 | 0.00 | T | 252.87 | 3.77 |
| aind-ibl-np1-CSHZAD026-slice10 | bandpass(300-6000Hz,o4) | lzma | lzma-preset_6 | 3.361 | 0.04 | 2.93 | 0.0000 | 0.0000 | 0.00 | T | 306.68 | 3.77 |
| aind-ibl-np1-CSHZAD026-slice10 | bandpass(300-6000Hz,o4) | zstd | zstd-level_22 | 3.129 | 0.04 | 26.66 | 0.0000 | 0.0000 | 0.00 | T | 383.89 | 3.77 |
| aind-ibl-np1-CSHZAD026-slice10 | bandpass(300-6000Hz,o4) | blosc-zstd | blosc-zstd-level_9-shuffle_byte | 2.803 | 0.56 | 100.22 | 0.0000 | 0.0000 | 0.00 | T | 103.04 | 3.77 |
| aind-ibl-np1-CSHZAD026-slice10 | bandpass(300-6000Hz,o4) | zstd | zstd-level_3 | 2.734 | 3.56 | 10.97 | 0.0000 | 0.0000 | 0.00 | T | 92.42 | 3.77 |
| aind-ibl-np1-CSHZAD026-slice10 | bandpass(300-6000Hz,o4) | blosc-zlib | blosc-zlib-level_9-shuffle_byte | 2.632 | 0.33 | 63.11 | 0.0000 | 0.0000 | 0.00 | T | 130.66 | 3.77 |
| aind-ibl-np1-CSHZAD026-slice10 | bandpass(300-6000Hz,o4) | zlib | zlib-level_5 | 2.604 | 0.78 | 7.34 | 0.0000 | 0.0000 | 0.00 | T | 95.03 | 3.77 |
| aind-ibl-np1-CSHZAD026-slice10 | bandpass(300-6000Hz,o4) | gzip | gzip-level_5 | 2.604 | 0.75 | 6.31 | 0.0000 | 0.0000 | 0.00 | T | 96.89 | 3.77 |
| aind-ibl-np1-CSHZAD026-slice10 | bandpass(300-6000Hz,o4) | blosc-zlib | blosc-zlib-level_3-shuffle_byte | 2.442 | 6.78 | 57.41 | 0.0000 | 0.0000 | 0.00 | T | 102.99 | 3.77 |
| aind-ibl-np1-CSHZAD026-slice10 | bandpass(300-6000Hz,o4) | blosc-zstd | blosc-zstd-level_3-shuffle_byte | 2.377 | 10.00 | 31.00 | 0.0000 | 0.0000 | 0.00 | T | 102.33 | 3.77 |
| aind-ibl-np1-CSHZAD026-slice10 | bandpass(300-6000Hz,o4) | blosc-lz4hc | blosc-lz4hc-level_9-shuffle_byte | 1.972 | 1.32 | 290.44 | 0.0000 | 0.0000 | 0.00 | T | 98.00 | 3.77 |
| aind-ibl-np1-CSHZAD026-slice10 | bandpass(300-6000Hz,o4) | blosc-lz4hc | blosc-lz4hc-level_3-shuffle_byte | 1.717 | 8.78 | 120.96 | 0.0000 | 0.0000 | 0.00 | T | 92.03 | 3.77 |
| aind-ibl-np1-CSHZAD026-slice10 | bandpass(300-6000Hz,o4) | lz4 | lz4-acceleration_1 | 1.662 | 10.90 | 40.04 | 0.0000 | 0.0000 | 0.00 | T | 85.90 | 3.77 |
| aind-ibl-np1-CSHZAD026-slice10 | bandpass(300-6000Hz,o4) | blosc-lz4 | blosc-lz4-level_9-shuffle_byte | 1.418 | 32.35 | 105.37 | 0.0000 | 0.0000 | 0.00 | T | 93.09 | 3.77 |
| aind-ibl-np1-CSHZAD026-slice10 | bandpass(300-6000Hz,o4) | blosc-lz4 | blosc-lz4-level_3-shuffle_byte | 1.357 | 60.16 | 133.78 | 0.0000 | 0.0000 | 0.00 | T | 81.51 | 3.77 |

## Highlights

- **Best lossless:** `t261` (t261-preset_combinedPresetEEG_IndepChannel_lossless) — CR 6.902.
- **Best lossy CR:** `t261` (t261-26ca7af3) — CR 23.500, RMSE 1.5320.
