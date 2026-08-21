# Sweep report (partial)

**Cells:** 87 total (71 lossless + 16 lossy).

One or more cells failed; report contains successful cells only.

| dataset | preproc | chunk | codec | params | CR | enc xRT | dec xRT | RMSE | RMSE_bp | PRDN/ch % | lossless | wall_s | RSS GB |
| --- | --- | --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | :---: | ---: | ---: |
| ibl-SWC054-probe01-bp | bandpass(300-6000Hz,o4) | whole | wavpack | wavpack-level_2-bps_2.25 | 7.234 | 1.61 | 6.36 | 0.9269 | 0.6121 | 15.22 | F | 272.54 | 10.76 |
| aind-634568-raw | raw | whole | wavpack | wavpack-level_2-bps_2.25 | 7.101 | 1.55 | 1.11 | 22.7723 | 17.9229 | 20.75 | F | 521.60 | 10.76 |
| aind-634568-raw | raw | 1s | wavpack | wavpack-level_2-bps_2.25-chunk1s | 7.067 | 1.11 | 5.22 | 22.7486 | 17.9044 | 20.74 | F | 200.14 | 10.84 |
| ibl-SWC054-probe01-bp | bandpass(300-6000Hz,o4) | whole | wavpack | wavpack-level_2-bps_2.5 | 7.038 | 1.58 | 4.45 | 0.8811 | 0.5639 | 14.68 | F | 380.03 | 10.76 |
| ibl-SWC054-probe01-bp | bandpass(300-6000Hz,o4) | 1s | wavpack | wavpack-level_2-bps_2.5-chunk1s | 7.009 | 1.15 | 2.25 | 0.8811 | 0.5638 | 14.70 | F | 357.32 | 10.99 |
| aind-634568-lsbbp | lsb12+bandpass(300-6000Hz,o4) | whole | wavpack | wavpack-level_2-bps_3.0 | 6.433 | 1.54 | 4.05 | 0.7533 | 0.4792 | 10.60 | F | 305.82 | 12.04 |
| ibl-SWC054-probe01-bp | bandpass(300-6000Hz,o4) | 1s | wavpack | wavpack-level_2-bps_3.0-chunk1s | 6.193 | 1.25 | 1.72 | 0.6258 | 0.3864 | 9.72 | F | 906.88 | 11.01 |
| aind-634568-lsbbp | lsb12+bandpass(300-6000Hz,o4) | whole | wavpack | wavpack-level_2-bps_3.5 | 5.814 | 1.45 | 1.53 | 0.4636 | 0.2621 | 6.86 | F | 677.65 | 12.04 |
| aind-634568-lsbbp | lsb12+bandpass(300-6000Hz,o4) | 1s | wavpack | wavpack-level_2-bps_3.5-chunk1s | 5.791 | 1.19 | 5.51 | 0.4636 | 0.2620 | 6.87 | F | 319.69 | 12.04 |
| ibl-CSHZAD026-bp | bandpass(300-6000Hz,o4) | whole | wavpack | wavpack-level_2-bps_4.0 | 5.516 | 1.57 | 6.63 | 0.0759 | 0.0430 | 0.00 | F | 286.74 | 10.76 |
| ibl-CSHZAD026-bp | bandpass(300-6000Hz,o4) | 1s | wavpack | wavpack-level_2-bps_4.0-chunk1s | 5.499 | 1.18 | 5.88 | 0.0806 | 0.0457 | 0.00 | F | 346.68 | 11.04 |
| ibl-CSHZAD026-bp | bandpass(300-6000Hz,o4) | 1s | wavpack | wavpack-level_2-bps_5.0-chunk1s | 5.485 | 1.19 | 5.38 | 0.0000 | 0.0000 | 0.00 | T | 302.99 | 10.75 |
| aind-634568-lsb | lsb12 | whole | t261 | t261-preset_combinedPresetEEG_IndepChannel_lossless | 3.645 | 0.08 | 0.18 | 0.0000 | 0.0000 | 0.00 | T | 1333.12 | 6.72 |
| aind-625749-lsb | lsb12 | whole | wavpack | wavpack-level_2 | 3.593 | 3.24 | 5.85 | 0.0000 | 0.0000 | 0.00 | T | 162.70 | 6.72 |
| aind-625749-lsb | lsb12 | whole | wavpack | wavpack-level_2-bps_6.0 | 3.593 | 1.55 | 4.47 | 0.0000 | 0.0000 | 0.00 | T | 151.49 | 6.72 |
| aind-625749-lsb | lsb12 | 1s | wavpack | wavpack-level_2-chunk1s | 3.586 | 1.83 | 1.71 | 0.0000 | 0.0000 | 0.00 | T | 149.64 | 6.72 |
| aind-625749-lsb | lsb12 | 1s | flac | flac-level_5-chunk1s | 3.444 | 0.56 | 1.26 | 0.0000 | 0.0000 | 0.00 | T | 570.72 | 9.01 |
| aind-634568-raw | raw | whole | wavpack | wavpack-level_2-bps_5.0 | 3.137 | 1.34 | 3.57 | 2.7727 | 2.1490 | 2.57 | F | 236.26 | 10.76 |
| ibl-CSHZAD029-bp | bandpass(300-6000Hz,o4) | whole | zstd | zstd-level_22 | 3.021 | 0.02 | 10.13 | 0.0000 | 0.0000 | 0.00 | T | 3242.26 | 10.75 |
| ibl-CSHZAD029-bp | bandpass(300-6000Hz,o4) | 1s | zstd | zstd-level_22-chunk1s | 2.950 | 0.04 | 9.31 | 0.0000 | 0.0000 | 0.00 | T | 1869.65 | 10.75 |
| ibl-CSHZAD029-bp | bandpass(300-6000Hz,o4) | whole | blosc-zstd | blosc-zstd-level_9-shuffle_none | 2.820 | 0.08 | 16.75 | 0.0000 | 0.0000 | 0.00 | T | 1192.13 | 10.75 |
| ibl-CSHZAD029-bp | bandpass(300-6000Hz,o4) | 1s | blosc-zstd | blosc-zstd-level_9-shuffle_none-chunk1s | 2.820 | 0.08 | 15.70 | 0.0000 | 0.0000 | 0.00 | T | 869.82 | 10.75 |
| ibl-CSHZAD029-bp | bandpass(300-6000Hz,o4) | whole | blosc-zstd | blosc-zstd-level_9-shuffle_byte | 2.739 | 0.08 | 17.16 | 0.0000 | 0.0000 | 0.00 | T | 904.14 | 10.75 |
| aind-634568-raw | raw | whole | wavpack | wavpack-level_2-bps_6.0 | 2.660 | 1.20 | 3.81 | 1.4490 | 1.0580 | 1.33 | F | 317.15 | 10.77 |
| aind-634568-raw | raw | 1s | wavpack | wavpack-level_2-bps_6.0-chunk1s | 2.657 | 0.99 | 1.86 | 1.4522 | 1.0592 | 1.33 | F | 266.85 | 10.84 |
| aind-634568-lsbbp | lsb12+bandpass(300-6000Hz,o4) | whole | zlib | zlib-level_9 | 2.574 | 0.10 | 9.70 | 0.0000 | 0.0000 | 0.00 | T | 749.30 | 12.04 |
| aind-634568-lsbbp | lsb12+bandpass(300-6000Hz,o4) | 1s | zlib | zlib-level_9-chunk1s | 2.574 | 0.10 | 11.82 | 0.0000 | 0.0000 | 0.00 | T | 792.54 | 12.04 |
| aind-634568-lsbbp | lsb12+bandpass(300-6000Hz,o4) | 1s | gzip | gzip-level_9-chunk1s | 2.574 | 0.10 | 4.18 | 0.0000 | 0.0000 | 0.00 | T | 1186.92 | 12.04 |
| aind-634569-lsb | lsb12 | whole | blosc-zlib | blosc-zlib-level_9-shuffle_byte | 2.481 | 0.03 | 9.39 | 0.0000 | 0.0000 | 0.00 | T | 2091.12 | 6.72 |
| aind-634569-lsb | lsb12 | whole | zlib | zlib-level_9 | 2.433 | 0.12 | 5.67 | 0.0000 | 0.0000 | 0.00 | T | 607.13 | 6.72 |
| aind-634569-lsb | lsb12 | 1s | zlib | zlib-level_9-chunk1s | 2.433 | 0.12 | 8.35 | 0.0000 | 0.0000 | 0.00 | T | 530.21 | 6.72 |
| aind-634569-lsb | lsb12 | 1s | gzip | gzip-level_9-chunk1s | 2.433 | 0.13 | 4.50 | 0.0000 | 0.0000 | 0.00 | T | 701.24 | 6.72 |
| aind-634569-lsb | lsb12 | 1s | blosc-zlib | blosc-zlib-level_9-shuffle_none-chunk1s | 2.411 | 0.13 | 2.45 | 0.0000 | 0.0000 | 0.00 | T | 835.83 | 6.72 |
| aind-634568-lsb | lsb12 | 1s | blosc-lz4hc | blosc-lz4hc-level_9-shuffle_bit-chunk1s | 2.411 | 3.62 | 52.16 | 0.0000 | 0.0000 | 0.00 | T | 77.02 | 6.72 |
| aind-634568-lsb | lsb12 | whole | blosc-lz4hc | blosc-lz4hc-level_9-shuffle_bit | 2.403 | 3.69 | 46.41 | 0.0000 | 0.0000 | 0.00 | T | 68.76 | 6.72 |
| aind-634571-lsbbp | lsb12+bandpass(300-6000Hz,o4) | 1s | blosc-lz4 | blosc-lz4-level_9-shuffle_bit-chunk1s | 2.336 | 38.74 | 6.95 | 0.0000 | 0.0000 | 0.00 | T | 149.17 | 12.04 |
| aind-634571-lsbbp | lsb12+bandpass(300-6000Hz,o4) | whole | blosc-lz4 | blosc-lz4-level_9-shuffle_bit | 2.330 | 39.05 | 43.70 | 0.0000 | 0.0000 | 0.00 | T | 175.07 | 12.04 |
| aind-625749-lsb | lsb12 | 1s | blosc-lz4 | blosc-lz4-level_9-shuffle_bit-chunk1s | 2.325 | 26.91 | 37.99 | 0.0000 | 0.0000 | 0.00 | T | 49.81 | 6.72 |
| aind-625749-lsb | lsb12 | whole | blosc-lz4 | blosc-lz4-level_9-shuffle_bit | 2.319 | 30.07 | 4.59 | 0.0000 | 0.0000 | 0.00 | T | 449.35 | 6.72 |
| ibl-SWC054-probe01-raw | raw | 1s | zstd | zstd-level_22-chunk1s | 2.276 | 0.03 | 8.29 | 0.0000 | 0.0000 | 0.00 | T | 1921.79 | 4.74 |
| ibl-CSHZAD029-raw | raw | whole | blosc-zlib | blosc-zlib-level_9-shuffle_byte | 2.221 | 0.03 | 6.56 | 0.0000 | 0.0000 | 0.00 | T | 2025.22 | 4.71 |
| ibl-CSHZAD029-raw | raw | 1s | blosc-zlib | blosc-zlib-level_9-shuffle_byte-chunk1s | 2.221 | 0.03 | 2.50 | 0.0000 | 0.0000 | 0.00 | T | 1992.37 | 4.74 |
| ibl-SWC054-probe01-bp | bandpass(300-6000Hz,o4) | 1s | blosc-lz4 | blosc-lz4-level_9-shuffle_bit-chunk1s | 2.218 | 32.53 | 41.68 | 0.0000 | 0.0000 | 0.00 | T | 130.03 | 10.75 |
| ibl-SWC054-probe01-bp | bandpass(300-6000Hz,o4) | whole | blosc-lz4 | blosc-lz4-level_9-shuffle_bit | 2.212 | 26.90 | 14.87 | 0.0000 | 0.0000 | 0.00 | T | 374.02 | 10.75 |
| ibl-SWC054-probe01-bp | bandpass(300-6000Hz,o4) | whole | blosc-lz4hc | blosc-lz4hc-level_9-shuffle_none | 2.138 | 0.19 | 38.63 | 0.0000 | 0.0000 | 0.00 | T | 426.25 | 10.75 |
| aind-634571-bp | bandpass(300-6000Hz,o4) | whole | flac | flac-level_5 | 2.038 | 3.65 | 5.34 | 0.0000 | 0.0000 | 0.00 | T | 137.95 | 10.75 |
| ibl-SWC054-probe00-raw | raw | whole | blosc-zstd | blosc-zstd-level_9-shuffle_none | 2.027 | 0.10 | 17.29 | 0.0000 | 0.0000 | 0.00 | T | 612.96 | 3.89 |
| aind-634568-raw | raw | 1s | wavpack | wavpack-level_2-chunk1s | 2.015 | 1.84 | 1.46 | 0.0000 | 0.0000 | 0.00 | T | 225.15 | 4.76 |
| aind-625749-raw | raw | whole | t261 | t261-preset_combinedPresetEEG_IndepChannel_lossless | 2.009 | 0.06 | 0.17 | 0.0000 | 0.0000 | 0.00 | T | 1370.70 | 5.89 |
| aind-625749-lsb | lsb12 | whole | blosc-lz4hc | blosc-lz4hc-level_9-shuffle_none | 1.973 | 0.36 | 46.10 | 0.0000 | 0.0000 | 0.00 | T | 283.21 | 6.72 |
| ibl-SWC054-probe01-raw | raw | 1s | blosc-zlib | blosc-zlib-level_9-shuffle_none-chunk1s | 1.952 | 0.26 | 4.63 | 0.0000 | 0.0000 | 0.00 | T | 275.24 | 4.74 |
| ibl-SWC054-probe01-raw | raw | whole | blosc-zlib | blosc-zlib-level_9-shuffle_none | 1.952 | 0.26 | 3.69 | 0.0000 | 0.0000 | 0.00 | T | 350.32 | 4.71 |
| ibl-CSHZAD026-raw | raw | 1s | blosc-zlib | blosc-zlib-level_9-shuffle_none-chunk1s | 1.933 | 0.26 | 7.88 | 0.0000 | 0.0000 | 0.00 | T | 245.85 | 3.77 |
| ibl-CSHZAD026-raw | raw | whole | blosc-zlib | blosc-zlib-level_9-shuffle_none | 1.933 | 0.26 | 2.36 | 0.0000 | 0.0000 | 0.00 | T | 292.02 | 4.71 |
| ibl-SWC054-probe00-bp | bandpass(300-6000Hz,o4) | whole | blosc-lz4 | blosc-lz4-level_9-shuffle_bit | 1.904 | 24.50 | 34.00 | 0.0000 | 0.0000 | 0.00 | T | 103.52 | 10.75 |
| aind-634568-bp | bandpass(300-6000Hz,o4) | 1s | blosc-zstd | blosc-zstd-level_9-shuffle_bit-chunk1s | 1.887 | 0.23 | 18.01 | 0.0000 | 0.0000 | 0.00 | T | 898.92 | 10.75 |
| aind-634569-raw | raw | 1s | blosc-lz4hc | blosc-lz4hc-level_9-shuffle_bit-chunk1s | 1.881 | 2.35 | 1.66 | 0.0000 | 0.0000 | 0.00 | T | 80.14 | 4.74 |
| aind-634571-bp | bandpass(300-6000Hz,o4) | whole | lzma | lzma-preset_9 | 1.832 | 0.03 | 1.54 | 0.0000 | 0.0000 | 0.00 | T | 2079.85 | 10.75 |
| aind-634571-bp | bandpass(300-6000Hz,o4) | 1s | lzma | lzma-preset_9-chunk1s | 1.817 | 0.05 | 1.24 | 0.0000 | 0.0000 | 0.00 | T | 1430.04 | 10.75 |
| aind-634568-lsb | lsb12 | 1s | blosc-lz4hc | blosc-lz4hc-level_9-shuffle_byte-chunk1s | 1.807 | 0.21 | 21.35 | 0.0000 | 0.0000 | 0.00 | T | 456.61 | 6.72 |
| aind-634568-lsb | lsb12 | whole | blosc-lz4hc | blosc-lz4hc-level_9-shuffle_byte | 1.807 | 0.21 | 2.68 | 0.0000 | 0.0000 | 0.00 | T | 640.09 | 6.72 |
| aind-625749-raw | raw | whole | blosc-lz4 | blosc-lz4-level_9-shuffle_bit | 1.740 | 20.54 | 11.47 | 0.0000 | 0.0000 | 0.00 | T | 25.89 | 4.71 |
| ibl-CSHZAD026-bp | bandpass(300-6000Hz,o4) | whole | blosc-lz4 | blosc-lz4-level_9-shuffle_none | 1.657 | 9.18 | 33.14 | 0.0000 | 0.0000 | 0.00 | T | 137.59 | 10.75 |
| aind-634569-lsbbp | lsb12+bandpass(300-6000Hz,o4) | 1s | blosc-lz4 | blosc-lz4-level_9-shuffle_none-chunk1s | 1.624 | 9.02 | 40.65 | 0.0000 | 0.0000 | 0.00 | T | 193.22 | 12.04 |
| aind-634569-lsbbp | lsb12+bandpass(300-6000Hz,o4) | whole | blosc-lz4 | blosc-lz4-level_9-shuffle_none | 1.623 | 12.99 | 43.31 | 0.0000 | 0.0000 | 0.00 | T | 159.43 | 12.04 |
| aind-634568-lsbbp | lsb12+bandpass(300-6000Hz,o4) | whole | lz4 | lz4-acceleration_1 | 1.607 | 8.40 | 32.35 | 0.0000 | 0.0000 | 0.00 | T | 163.06 | 12.04 |
| ibl-CSHZAD029-bp | bandpass(300-6000Hz,o4) | 1s | blosc-lz4 | blosc-lz4-level_9-shuffle_none-chunk1s | 1.575 | 10.94 | 44.89 | 0.0000 | 0.0000 | 0.00 | T | 126.34 | 10.75 |
| ibl-CSHZAD029-bp | bandpass(300-6000Hz,o4) | whole | blosc-lz4 | blosc-lz4-level_9-shuffle_none | 1.575 | 11.32 | 6.64 | 0.0000 | 0.0000 | 0.00 | T | 216.41 | 10.75 |
| aind-634571-lsbbp | lsb12+bandpass(300-6000Hz,o4) | 1s | blosc-lz4 | blosc-lz4-level_9-shuffle_byte-chunk1s | 1.544 | 29.72 | 43.54 | 0.0000 | 0.0000 | 0.00 | T | 643.96 | 12.04 |
| ibl-SWC054-probe00-bp | bandpass(300-6000Hz,o4) | whole | blosc-lz4 | blosc-lz4-level_9-shuffle_byte | 1.526 | 27.06 | 3.82 | 0.0000 | 0.0000 | 0.00 | T | 176.43 | 10.75 |
| ibl-SWC054-probe00-bp | bandpass(300-6000Hz,o4) | 1s | blosc-lz4 | blosc-lz4-level_9-shuffle_byte-chunk1s | 1.526 | 33.63 | 43.84 | 0.0000 | 0.0000 | 0.00 | T | 100.23 | 10.75 |
| aind-634569-lsb | lsb12 | whole | lz4 | lz4-acceleration_1 | 1.500 | 10.65 | 37.04 | 0.0000 | 0.0000 | 0.00 | T | 47.48 | 6.72 |
| aind-625749-raw | raw | whole | blosc-lz4 | blosc-lz4-level_9-shuffle_byte | 1.486 | 19.31 | 2.91 | 0.0000 | 0.0000 | 0.00 | T | 142.41 | 4.74 |
| aind-625749-raw | raw | 1s | blosc-lz4 | blosc-lz4-level_9-shuffle_byte-chunk1s | 1.486 | 27.27 | 10.10 | 0.0000 | 0.0000 | 0.00 | T | 16.61 | 4.71 |
| aind-634569-bp | bandpass(300-6000Hz,o4) | 1s | zlib | zlib-level_9-chunk1s | 1.484 | 0.55 | 4.01 | 0.0000 | 0.0000 | 0.00 | T | 650.23 | 10.75 |
| aind-634568-bp | bandpass(300-6000Hz,o4) | whole | gzip | gzip-level_9 | 1.471 | 0.56 | 4.60 | 0.0000 | 0.0000 | 0.00 | T | 234.57 | 10.75 |
| aind-634568-bp | bandpass(300-6000Hz,o4) | 1s | gzip | gzip-level_9-chunk1s | 1.471 | 0.60 | 5.54 | 0.0000 | 0.0000 | 0.00 | T | 231.95 | 10.75 |
| aind-634569-raw | raw | 1s | blosc-zlib | blosc-zlib-level_9-shuffle_none-chunk1s | 1.469 | 0.62 | 5.26 | 0.0000 | 0.0000 | 0.00 | T | 126.32 | 4.71 |
| aind-634569-raw | raw | whole | blosc-zlib | blosc-zlib-level_9-shuffle_none | 1.469 | 0.65 | 5.91 | 0.0000 | 0.0000 | 0.00 | T | 108.77 | 4.69 |
| ibl-CSHZAD029-bp | bandpass(300-6000Hz,o4) | whole | blosc-lz4 | blosc-lz4-level_9-shuffle_byte | 1.445 | 25.89 | 8.83 | 0.0000 | 0.0000 | 0.00 | T | 121.67 | 10.75 |
| ibl-CSHZAD029-raw | raw | whole | blosc-zlib | blosc-zlib-level_9-shuffle_bit | 1.295 | 0.58 | 7.01 | 0.0000 | 0.0000 | 0.00 | T | 119.82 | 4.50 |
| ibl-SWC054-probe00-raw | raw | 1s | blosc-zlib | blosc-zlib-level_9-shuffle_bit-chunk1s | 1.256 | 0.40 | 3.60 | 0.0000 | 0.0000 | 0.00 | T | 181.95 | 4.71 |
| ibl-SWC054-probe00-raw | raw | whole | blosc-zlib | blosc-zlib-level_9-shuffle_bit | 1.244 | 0.40 | 1.68 | 0.0000 | 0.0000 | 0.00 | T | 225.69 | 5.01 |
| ibl-SWC054-probe00-raw | raw | whole | lz4 | lz4-acceleration_1 | 1.114 | 6.21 | 1.77 | 0.0000 | 0.0000 | 0.00 | T | 183.85 | 5.12 |
| ibl-SWC054-probe00-raw | raw | 1s | lz4 | lz4-acceleration_1-chunk1s | 1.114 | 11.66 | 16.57 | 0.0000 | 0.0000 | 0.00 | T | 28.44 | 4.71 |
| aind-634569-bp | bandpass(300-6000Hz,o4) | 1s | lz4 | lz4-acceleration_1-chunk1s | 0.998 | 35.56 | 4.73 | 0.0000 | 0.0000 | 0.00 | T | 146.18 | 10.75 |
| aind-634569-bp | bandpass(300-6000Hz,o4) | whole | lz4 | lz4-acceleration_1 | 0.998 | 27.12 | 48.01 | 0.0000 | 0.0000 | 0.00 | T | 152.29 | 10.75 |

## Median CR across 20 datasets

The paper reports distributions over its recording set; this is the comparable per-codec figure. `n` is the number of datasets contributing — a short `n` means cells are still missing or failed.

| preproc @ chunk | codec | params | median CR | min | max | n |
| --- | --- | --- | ---: | ---: | ---: | ---: |
| bandpass(300-6000Hz,o4) @ 1s | wavpack | wavpack-level_2-bps_2.5-chunk1s | 7.009 | 7.009 | 7.009 | 1 |
| bandpass(300-6000Hz,o4) @ 1s | wavpack | wavpack-level_2-bps_3.0-chunk1s | 6.193 | 6.193 | 6.193 | 1 |
| bandpass(300-6000Hz,o4) @ 1s | wavpack | wavpack-level_2-bps_4.0-chunk1s | 5.499 | 5.499 | 5.499 | 1 |
| bandpass(300-6000Hz,o4) @ 1s | wavpack | wavpack-level_2-bps_5.0-chunk1s | 5.485 | 5.485 | 5.485 | 1 |
| bandpass(300-6000Hz,o4) @ 1s | zstd | zstd-level_22-chunk1s | 2.950 | 2.950 | 2.950 | 1 |
| bandpass(300-6000Hz,o4) @ 1s | blosc-zstd | blosc-zstd-level_9-shuffle_none-chunk1s | 2.820 | 2.820 | 2.820 | 1 |
| bandpass(300-6000Hz,o4) @ 1s | blosc-lz4 | blosc-lz4-level_9-shuffle_bit-chunk1s | 2.218 | 2.218 | 2.218 | 1 |
| bandpass(300-6000Hz,o4) @ 1s | blosc-zstd | blosc-zstd-level_9-shuffle_bit-chunk1s | 1.887 | 1.887 | 1.887 | 1 |
| bandpass(300-6000Hz,o4) @ 1s | lzma | lzma-preset_9-chunk1s | 1.817 | 1.817 | 1.817 | 1 |
| bandpass(300-6000Hz,o4) @ 1s | blosc-lz4 | blosc-lz4-level_9-shuffle_none-chunk1s | 1.575 | 1.575 | 1.575 | 1 |
| bandpass(300-6000Hz,o4) @ 1s | blosc-lz4 | blosc-lz4-level_9-shuffle_byte-chunk1s | 1.526 | 1.526 | 1.526 | 1 |
| bandpass(300-6000Hz,o4) @ 1s | zlib | zlib-level_9-chunk1s | 1.484 | 1.484 | 1.484 | 1 |
| bandpass(300-6000Hz,o4) @ 1s | gzip | gzip-level_9-chunk1s | 1.471 | 1.471 | 1.471 | 1 |
| bandpass(300-6000Hz,o4) @ 1s | lz4 | lz4-acceleration_1-chunk1s | 0.998 | 0.998 | 0.998 | 1 |
| bandpass(300-6000Hz,o4) @ whole | wavpack | wavpack-level_2-bps_2.25 | 7.234 | 7.234 | 7.234 | 1 |
| bandpass(300-6000Hz,o4) @ whole | wavpack | wavpack-level_2-bps_2.5 | 7.038 | 7.038 | 7.038 | 1 |
| bandpass(300-6000Hz,o4) @ whole | wavpack | wavpack-level_2-bps_4.0 | 5.516 | 5.516 | 5.516 | 1 |
| bandpass(300-6000Hz,o4) @ whole | zstd | zstd-level_22 | 3.021 | 3.021 | 3.021 | 1 |
| bandpass(300-6000Hz,o4) @ whole | blosc-zstd | blosc-zstd-level_9-shuffle_none | 2.820 | 2.820 | 2.820 | 1 |
| bandpass(300-6000Hz,o4) @ whole | blosc-zstd | blosc-zstd-level_9-shuffle_byte | 2.739 | 2.739 | 2.739 | 1 |
| bandpass(300-6000Hz,o4) @ whole | blosc-lz4hc | blosc-lz4hc-level_9-shuffle_none | 2.138 | 2.138 | 2.138 | 1 |
| bandpass(300-6000Hz,o4) @ whole | blosc-lz4 | blosc-lz4-level_9-shuffle_bit | 2.058 | 1.904 | 2.212 | 2 |
| bandpass(300-6000Hz,o4) @ whole | flac | flac-level_5 | 2.038 | 2.038 | 2.038 | 1 |
| bandpass(300-6000Hz,o4) @ whole | lzma | lzma-preset_9 | 1.832 | 1.832 | 1.832 | 1 |
| bandpass(300-6000Hz,o4) @ whole | blosc-lz4 | blosc-lz4-level_9-shuffle_none | 1.616 | 1.575 | 1.657 | 2 |
| bandpass(300-6000Hz,o4) @ whole | blosc-lz4 | blosc-lz4-level_9-shuffle_byte | 1.486 | 1.445 | 1.526 | 2 |
| bandpass(300-6000Hz,o4) @ whole | gzip | gzip-level_9 | 1.471 | 1.471 | 1.471 | 1 |
| bandpass(300-6000Hz,o4) @ whole | lz4 | lz4-acceleration_1 | 0.998 | 0.998 | 0.998 | 1 |
| lsb12 @ 1s | wavpack | wavpack-level_2-chunk1s | 3.586 | 3.586 | 3.586 | 1 |
| lsb12 @ 1s | flac | flac-level_5-chunk1s | 3.444 | 3.444 | 3.444 | 1 |
| lsb12 @ 1s | zlib | zlib-level_9-chunk1s | 2.433 | 2.433 | 2.433 | 1 |
| lsb12 @ 1s | gzip | gzip-level_9-chunk1s | 2.433 | 2.433 | 2.433 | 1 |
| lsb12 @ 1s | blosc-zlib | blosc-zlib-level_9-shuffle_none-chunk1s | 2.411 | 2.411 | 2.411 | 1 |
| lsb12 @ 1s | blosc-lz4hc | blosc-lz4hc-level_9-shuffle_bit-chunk1s | 2.411 | 2.411 | 2.411 | 1 |
| lsb12 @ 1s | blosc-lz4 | blosc-lz4-level_9-shuffle_bit-chunk1s | 2.325 | 2.325 | 2.325 | 1 |
| lsb12 @ 1s | blosc-lz4hc | blosc-lz4hc-level_9-shuffle_byte-chunk1s | 1.807 | 1.807 | 1.807 | 1 |
| lsb12 @ whole | t261 | t261-preset_combinedPresetEEG_IndepChannel_lossless | 3.645 | 3.645 | 3.645 | 1 |
| lsb12 @ whole | wavpack | wavpack-level_2 | 3.593 | 3.593 | 3.593 | 1 |
| lsb12 @ whole | wavpack | wavpack-level_2-bps_6.0 | 3.593 | 3.593 | 3.593 | 1 |
| lsb12 @ whole | blosc-zlib | blosc-zlib-level_9-shuffle_byte | 2.481 | 2.481 | 2.481 | 1 |
| lsb12 @ whole | zlib | zlib-level_9 | 2.433 | 2.433 | 2.433 | 1 |
| lsb12 @ whole | blosc-lz4hc | blosc-lz4hc-level_9-shuffle_bit | 2.403 | 2.403 | 2.403 | 1 |
| lsb12 @ whole | blosc-lz4 | blosc-lz4-level_9-shuffle_bit | 2.319 | 2.319 | 2.319 | 1 |
| lsb12 @ whole | blosc-lz4hc | blosc-lz4hc-level_9-shuffle_none | 1.973 | 1.973 | 1.973 | 1 |
| lsb12 @ whole | blosc-lz4hc | blosc-lz4hc-level_9-shuffle_byte | 1.807 | 1.807 | 1.807 | 1 |
| lsb12 @ whole | lz4 | lz4-acceleration_1 | 1.500 | 1.500 | 1.500 | 1 |
| lsb12+bandpass(300-6000Hz,o4) @ 1s | wavpack | wavpack-level_2-bps_3.5-chunk1s | 5.791 | 5.791 | 5.791 | 1 |
| lsb12+bandpass(300-6000Hz,o4) @ 1s | zlib | zlib-level_9-chunk1s | 2.574 | 2.574 | 2.574 | 1 |
| lsb12+bandpass(300-6000Hz,o4) @ 1s | gzip | gzip-level_9-chunk1s | 2.574 | 2.574 | 2.574 | 1 |
| lsb12+bandpass(300-6000Hz,o4) @ 1s | blosc-lz4 | blosc-lz4-level_9-shuffle_bit-chunk1s | 2.336 | 2.336 | 2.336 | 1 |
| lsb12+bandpass(300-6000Hz,o4) @ 1s | blosc-lz4 | blosc-lz4-level_9-shuffle_none-chunk1s | 1.624 | 1.624 | 1.624 | 1 |
| lsb12+bandpass(300-6000Hz,o4) @ 1s | blosc-lz4 | blosc-lz4-level_9-shuffle_byte-chunk1s | 1.544 | 1.544 | 1.544 | 1 |
| lsb12+bandpass(300-6000Hz,o4) @ whole | wavpack | wavpack-level_2-bps_3.0 | 6.433 | 6.433 | 6.433 | 1 |
| lsb12+bandpass(300-6000Hz,o4) @ whole | wavpack | wavpack-level_2-bps_3.5 | 5.814 | 5.814 | 5.814 | 1 |
| lsb12+bandpass(300-6000Hz,o4) @ whole | zlib | zlib-level_9 | 2.574 | 2.574 | 2.574 | 1 |
| lsb12+bandpass(300-6000Hz,o4) @ whole | blosc-lz4 | blosc-lz4-level_9-shuffle_bit | 2.330 | 2.330 | 2.330 | 1 |
| lsb12+bandpass(300-6000Hz,o4) @ whole | blosc-lz4 | blosc-lz4-level_9-shuffle_none | 1.623 | 1.623 | 1.623 | 1 |
| lsb12+bandpass(300-6000Hz,o4) @ whole | lz4 | lz4-acceleration_1 | 1.607 | 1.607 | 1.607 | 1 |
| raw @ 1s | wavpack | wavpack-level_2-bps_2.25-chunk1s | 7.067 | 7.067 | 7.067 | 1 |
| raw @ 1s | wavpack | wavpack-level_2-bps_6.0-chunk1s | 2.657 | 2.657 | 2.657 | 1 |
| raw @ 1s | zstd | zstd-level_22-chunk1s | 2.276 | 2.276 | 2.276 | 1 |
| raw @ 1s | blosc-zlib | blosc-zlib-level_9-shuffle_byte-chunk1s | 2.221 | 2.221 | 2.221 | 1 |
| raw @ 1s | wavpack | wavpack-level_2-chunk1s | 2.015 | 2.015 | 2.015 | 1 |
| raw @ 1s | blosc-zlib | blosc-zlib-level_9-shuffle_none-chunk1s | 1.933 | 1.469 | 1.952 | 3 |
| raw @ 1s | blosc-lz4hc | blosc-lz4hc-level_9-shuffle_bit-chunk1s | 1.881 | 1.881 | 1.881 | 1 |
| raw @ 1s | blosc-lz4 | blosc-lz4-level_9-shuffle_byte-chunk1s | 1.486 | 1.486 | 1.486 | 1 |
| raw @ 1s | blosc-zlib | blosc-zlib-level_9-shuffle_bit-chunk1s | 1.256 | 1.256 | 1.256 | 1 |
| raw @ 1s | lz4 | lz4-acceleration_1-chunk1s | 1.114 | 1.114 | 1.114 | 1 |
| raw @ whole | wavpack | wavpack-level_2-bps_2.25 | 7.101 | 7.101 | 7.101 | 1 |
| raw @ whole | wavpack | wavpack-level_2-bps_5.0 | 3.137 | 3.137 | 3.137 | 1 |
| raw @ whole | wavpack | wavpack-level_2-bps_6.0 | 2.660 | 2.660 | 2.660 | 1 |
| raw @ whole | blosc-zlib | blosc-zlib-level_9-shuffle_byte | 2.221 | 2.221 | 2.221 | 1 |
| raw @ whole | blosc-zstd | blosc-zstd-level_9-shuffle_none | 2.027 | 2.027 | 2.027 | 1 |
| raw @ whole | t261 | t261-preset_combinedPresetEEG_IndepChannel_lossless | 2.009 | 2.009 | 2.009 | 1 |
| raw @ whole | blosc-zlib | blosc-zlib-level_9-shuffle_none | 1.933 | 1.469 | 1.952 | 3 |
| raw @ whole | blosc-lz4 | blosc-lz4-level_9-shuffle_bit | 1.740 | 1.740 | 1.740 | 1 |
| raw @ whole | blosc-lz4 | blosc-lz4-level_9-shuffle_byte | 1.486 | 1.486 | 1.486 | 1 |
| raw @ whole | blosc-zlib | blosc-zlib-level_9-shuffle_bit | 1.269 | 1.244 | 1.295 | 2 |
| raw @ whole | lz4 | lz4-acceleration_1 | 1.114 | 1.114 | 1.114 | 1 |

## Highlights

- **Best lossless:** `t261` (t261-preset_combinedPresetEEG_IndepChannel_lossless) — CR 3.645.
- **Best lossy CR:** `wavpack` (wavpack-level_2-bps_2.25) — CR 7.234, RMSE 0.9269.
