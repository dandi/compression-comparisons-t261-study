# Sweep report

**Cells:** 72 total (72 lossless + 0 lossy).

Auto-rendered post-sweep.

| dataset                | preproc | chunk | codec       | params                                   |    CR | enc xRT | dec xRT |   RMSE | RMSE_bp | PRDN/ch % | lossless |   wall_s | RSS GB |
| ---------------------- | ------- | ----- | ----------- | ---------------------------------------- | ----: | ------: | ------: | -----: | ------: | --------: | :------: | -------: | -----: |
| aind-625749-lsb        | lsb12   | 1s    | lzma        | lzma-preset_9-shuffle_byte-chunk1s       | 2.821 |    0.08 |    1.68 | 0.0000 |  0.0000 |      0.00 |    T     | 25837.66 |  97.64 |
| aind-634571-lsb        | lsb12   | 1s    | lzma        | lzma-preset_9-shuffle_byte-chunk1s       | 2.740 |    0.06 |    1.92 | 0.0000 |  0.0000 |      0.00 |    T     | 34728.22 |  97.52 |
| aind-625749-lsb        | lsb12   | 1s    | zstd        | zstd-level_22-shuffle_byte-chunk1s       | 2.738 |    0.08 |   11.34 | 0.0000 |  0.0000 |      0.00 |    T     | 22518.84 |  97.61 |
| aind-634568-lsb        | lsb12   | 1s    | lzma        | lzma-preset_9-shuffle_byte-chunk1s       | 2.677 |    0.06 |    2.56 | 0.0000 |  0.0000 |      0.00 |    T     | 31745.69 |  94.84 |
| aind-625749-lsb        | lsb12   | 1s    | blosc-zstd  | blosc-zstd-level_9-shuffle_byte-chunk1s  | 2.666 |    0.16 |    7.41 | 0.0000 |  0.0000 |      0.00 |    T     | 13059.54 |  97.61 |
| aind-634571-lsb        | lsb12   | 1s    | zstd        | zstd-level_22-shuffle_byte-chunk1s       | 2.663 |    0.07 |   17.14 | 0.0000 |  0.0000 |      0.00 |    T     | 27675.18 |  97.55 |
| aind-634569-lsb        | lsb12   | 1s    | lzma        | lzma-preset_9-shuffle_byte-chunk1s       | 2.662 |    0.05 |    2.23 | 0.0000 |  0.0000 |      0.00 |    T     | 38206.87 |  93.50 |
| aind-634568-lsb        | lsb12   | 1s    | blosc-zstd  | blosc-zstd-level_9-shuffle_byte-chunk1s  | 2.597 |    0.12 |   14.81 | 0.0000 |  0.0000 |      0.00 |    T     | 16524.44 |  94.88 |
| aind-634568-lsb        | lsb12   | 1s    | zstd        | zstd-level_22-shuffle_byte-chunk1s       | 2.594 |    0.06 |    3.49 | 0.0000 |  0.0000 |      0.00 |    T     | 31456.46 |  94.88 |
| aind-625749-lsb        | lsb12   | 1s    | zlib        | zlib-level_9-shuffle_byte-chunk1s        | 2.579 |    0.06 |    9.15 | 0.0000 |  0.0000 |      0.00 |    T     | 30765.00 |  97.61 |
| aind-625749-lsb        | lsb12   | 1s    | gzip        | gzip-level_9-shuffle_byte-chunk1s        | 2.579 |    0.06 |    6.30 | 0.0000 |  0.0000 |      0.00 |    T     | 34352.02 | 103.22 |
| aind-625749-lsb        | lsb12   | 1s    | blosc-zlib  | blosc-zlib-level_9-shuffle_byte-chunk1s  | 2.576 |    0.06 |   10.31 | 0.0000 |  0.0000 |      0.00 |    T     | 29691.33 |  97.64 |
| aind-634569-lsb        | lsb12   | 1s    | zstd        | zstd-level_22-shuffle_byte-chunk1s       | 2.566 |    0.06 |    4.33 | 0.0000 |  0.0000 |      0.00 |    T     | 32014.86 |  93.50 |
| aind-634571-lsb        | lsb12   | 1s    | blosc-zstd  | blosc-zstd-level_9-shuffle_byte-chunk1s  | 2.557 |    0.17 |   27.96 | 0.0000 |  0.0000 |      0.00 |    T     | 14698.41 |  97.51 |
| aind-634569-lsb        | lsb12   | 1s    | blosc-zstd  | blosc-zstd-level_9-shuffle_byte-chunk1s  | 2.554 |    0.15 |   25.75 | 0.0000 |  0.0000 |      0.00 |    T     | 14271.53 |  93.53 |
| aind-634571-lsb        | lsb12   | 1s    | zlib        | zlib-level_9-shuffle_byte-chunk1s        | 2.495 |    0.06 |    7.43 | 0.0000 |  0.0000 |      0.00 |    T     | 34360.51 |  97.49 |
| aind-634571-lsb        | lsb12   | 1s    | gzip        | gzip-level_9-shuffle_byte-chunk1s        | 2.495 |    0.06 |    3.28 | 0.0000 |  0.0000 |      0.00 |    T     | 33970.74 | 103.32 |
| aind-634568-lsb        | lsb12   | 1s    | zlib        | zlib-level_9-shuffle_byte-chunk1s        | 2.492 |    0.03 |    8.89 | 0.0000 |  0.0000 |      0.00 |    T     | 57996.31 |  94.87 |
| aind-634568-lsb        | lsb12   | 1s    | gzip        | gzip-level_9-shuffle_byte-chunk1s        | 2.492 |    0.03 |    2.25 | 0.0000 |  0.0000 |      0.00 |    T     | 62876.02 | 110.11 |
| aind-634571-lsb        | lsb12   | 1s    | blosc-zlib  | blosc-zlib-level_9-shuffle_byte-chunk1s  | 2.492 |    0.05 |    6.68 | 0.0000 |  0.0000 |      0.00 |    T     | 35143.28 |  97.54 |
| aind-634568-lsb        | lsb12   | 1s    | blosc-zlib  | blosc-zlib-level_9-shuffle_byte-chunk1s  | 2.488 |    0.03 |   10.80 | 0.0000 |  0.0000 |      0.00 |    T     | 58328.21 |  94.91 |
| ibl-CSHZAD026-raw      | raw     | 1s    | lzma        | lzma-preset_9-shuffle_byte-chunk1s       | 2.473 |    0.09 |    2.36 | 0.0000 |  0.0000 |      0.00 |    T     | 13727.35 |  64.50 |
| aind-634569-lsb        | lsb12   | 1s    | zlib        | zlib-level_9-shuffle_byte-chunk1s        | 2.468 |    0.03 |    2.62 | 0.0000 |  0.0000 |      0.00 |    T     | 53677.57 |  93.53 |
| aind-634569-lsb        | lsb12   | 1s    | gzip        | gzip-level_9-shuffle_byte-chunk1s        | 2.468 |    0.03 |    2.15 | 0.0000 |  0.0000 |      0.00 |    T     | 54041.09 | 108.73 |
| aind-634569-lsb        | lsb12   | 1s    | blosc-zlib  | blosc-zlib-level_9-shuffle_byte-chunk1s  | 2.464 |    0.03 |   10.45 | 0.0000 |  0.0000 |      0.00 |    T     | 51456.01 |  93.53 |
| ibl-SWC054-probe01-raw | raw     | 1s    | lzma        | lzma-preset_9-shuffle_byte-chunk1s       | 2.430 |    0.08 |    2.33 | 0.0000 |  0.0000 |      0.00 |    T     | 14941.69 |  64.50 |
| ibl-CSHZAD029-raw      | raw     | 1s    | lzma        | lzma-preset_9-shuffle_byte-chunk1s       | 2.408 |    0.07 |    2.05 | 0.0000 |  0.0000 |      0.00 |    T     | 17441.89 |  64.54 |
| ibl-CSHZAD026-raw      | raw     | 1s    | zstd        | zstd-level_22-shuffle_byte-chunk1s       | 2.342 |    0.08 |    3.59 | 0.0000 |  0.0000 |      0.00 |    T     | 16161.97 |  64.50 |
| ibl-SWC054-probe01-raw | raw     | 1s    | zstd        | zstd-level_22-shuffle_byte-chunk1s       | 2.337 |    0.10 |    7.46 | 0.0000 |  0.0000 |      0.00 |    T     | 12880.06 |  64.50 |
| ibl-SWC054-probe01-raw | raw     | 1s    | blosc-zstd  | blosc-zstd-level_9-shuffle_byte-chunk1s  | 2.326 |    0.15 |   32.75 | 0.0000 |  0.0000 |      0.00 |    T     |  7975.33 |  64.54 |
| ibl-CSHZAD026-raw      | raw     | 1s    | blosc-zstd  | blosc-zstd-level_9-shuffle_byte-chunk1s  | 2.323 |    0.12 |    3.69 | 0.0000 |  0.0000 |      0.00 |    T     | 10842.39 |  64.54 |
| ibl-CSHZAD029-raw      | raw     | 1s    | zstd        | zstd-level_22-shuffle_byte-chunk1s       | 2.301 |    0.10 |   26.66 | 0.0000 |  0.0000 |      0.00 |    T     | 12131.00 |  64.25 |
| ibl-CSHZAD029-raw      | raw     | 1s    | blosc-zstd  | blosc-zstd-level_9-shuffle_byte-chunk1s  | 2.289 |    0.15 |   33.10 | 0.0000 |  0.0000 |      0.00 |    T     |  7931.30 |  64.54 |
| ibl-SWC054-probe00-raw | raw     | 1s    | lzma        | lzma-preset_9-shuffle_byte-chunk1s       | 2.279 |    0.07 |    1.92 | 0.0000 |  0.0000 |      0.00 |    T     | 16915.79 |  64.51 |
| ibl-CSHZAD026-raw      | raw     | 1s    | zlib        | zlib-level_9-shuffle_byte-chunk1s        | 2.254 |    0.04 |    0.98 | 0.0000 |  0.0000 |      0.00 |    T     | 34896.40 |  64.50 |
| ibl-CSHZAD026-raw      | raw     | 1s    | gzip        | gzip-level_9-shuffle_byte-chunk1s        | 2.254 |    0.03 |    8.69 | 0.0000 |  0.0000 |      0.00 |    T     | 36362.08 |  64.52 |
| ibl-SWC054-probe01-raw | raw     | 1s    | zlib        | zlib-level_9-shuffle_byte-chunk1s        | 2.254 |    0.03 |    3.65 | 0.0000 |  0.0000 |      0.00 |    T     | 43993.00 |  64.50 |
| ibl-SWC054-probe01-raw | raw     | 1s    | gzip        | gzip-level_9-shuffle_byte-chunk1s        | 2.254 |    0.03 |    8.49 | 0.0000 |  0.0000 |      0.00 |    T     | 40161.26 |  67.91 |
| ibl-CSHZAD026-raw      | raw     | 1s    | blosc-zlib  | blosc-zlib-level_9-shuffle_byte-chunk1s  | 2.251 |    0.04 |   11.87 | 0.0000 |  0.0000 |      0.00 |    T     | 32904.89 |  64.54 |
| ibl-SWC054-probe01-raw | raw     | 1s    | blosc-zlib  | blosc-zlib-level_9-shuffle_byte-chunk1s  | 2.250 |    0.03 |    9.00 | 0.0000 |  0.0000 |      0.00 |    T     | 39626.85 |  64.54 |
| ibl-CSHZAD029-raw      | raw     | 1s    | zlib        | zlib-level_9-shuffle_byte-chunk1s        | 2.222 |    0.03 |    7.58 | 0.0000 |  0.0000 |      0.00 |    T     | 35155.34 |  64.50 |
| ibl-CSHZAD029-raw      | raw     | 1s    | gzip        | gzip-level_9-shuffle_byte-chunk1s        | 2.222 |    0.03 |    7.62 | 0.0000 |  0.0000 |      0.00 |    T     | 35340.43 |  70.23 |
| ibl-CSHZAD029-raw      | raw     | 1s    | blosc-zlib  | blosc-zlib-level_9-shuffle_byte-chunk1s  | 2.219 |    0.04 |    4.23 | 0.0000 |  0.0000 |      0.00 |    T     | 34120.60 |  64.53 |
| ibl-SWC054-probe00-raw | raw     | 1s    | zstd        | zstd-level_22-shuffle_byte-chunk1s       | 2.175 |    0.10 |   15.53 | 0.0000 |  0.0000 |      0.00 |    T     | 11656.02 |  64.51 |
| ibl-SWC054-probe00-raw | raw     | 1s    | blosc-zstd  | blosc-zstd-level_9-shuffle_byte-chunk1s  | 2.162 |    0.16 |   14.52 | 0.0000 |  0.0000 |      0.00 |    T     |  7481.23 |  64.55 |
| ibl-SWC054-probe00-raw | raw     | 1s    | zlib        | zlib-level_9-shuffle_byte-chunk1s        | 2.115 |    0.04 |    8.61 | 0.0000 |  0.0000 |      0.00 |    T     | 32045.13 |  64.50 |
| ibl-SWC054-probe00-raw | raw     | 1s    | gzip        | gzip-level_9-shuffle_byte-chunk1s        | 2.115 |    0.04 |    4.36 | 0.0000 |  0.0000 |      0.00 |    T     | 32247.36 |  64.57 |
| ibl-SWC054-probe00-raw | raw     | 1s    | blosc-zlib  | blosc-zlib-level_9-shuffle_byte-chunk1s  | 2.112 |    0.04 |   11.84 | 0.0000 |  0.0000 |      0.00 |    T     | 31034.11 |  64.54 |
| aind-625749-lsb        | lsb12   | 1s    | blosc-lz4hc | blosc-lz4hc-level_9-shuffle_byte-chunk1s | 1.916 |    0.33 |   19.14 | 0.0000 |  0.0000 |      0.00 |    T     |  6541.39 |  98.18 |
| aind-634571-lsb        | lsb12   | 1s    | blosc-lz4hc | blosc-lz4hc-level_9-shuffle_byte-chunk1s | 1.871 |    0.28 |   10.10 | 0.0000 |  0.0000 |      0.00 |    T     |  8307.63 |  98.75 |
| aind-634568-lsb        | lsb12   | 1s    | blosc-lz4hc | blosc-lz4hc-level_9-shuffle_byte-chunk1s | 1.813 |    0.25 |   51.74 | 0.0000 |  0.0000 |      0.00 |    T     |  7964.13 |  96.62 |
| aind-634569-lsb        | lsb12   | 1s    | blosc-lz4hc | blosc-lz4hc-level_9-shuffle_byte-chunk1s | 1.811 |    0.26 |    6.30 | 0.0000 |  0.0000 |      0.00 |    T     |  8032.77 |  95.46 |
| ibl-CSHZAD026-raw      | raw     | 1s    | blosc-lz4hc | blosc-lz4hc-level_9-shuffle_byte-chunk1s | 1.712 |    0.35 |   69.68 | 0.0000 |  0.0000 |      0.00 |    T     |  3561.61 |  66.58 |
| ibl-CSHZAD029-raw      | raw     | 1s    | blosc-lz4hc | blosc-lz4hc-level_9-shuffle_byte-chunk1s | 1.703 |    0.32 |   69.40 | 0.0000 |  0.0000 |      0.00 |    T     |  3799.81 |  66.39 |
| ibl-SWC054-probe00-raw | raw     | 1s    | blosc-lz4hc | blosc-lz4hc-level_9-shuffle_byte-chunk1s | 1.698 |    0.26 |   33.62 | 0.0000 |  0.0000 |      0.00 |    T     |  4821.65 |  66.36 |
| ibl-SWC054-probe01-raw | raw     | 1s    | blosc-lz4hc | blosc-lz4hc-level_9-shuffle_byte-chunk1s | 1.688 |    0.28 |   71.21 | 0.0000 |  0.0000 |      0.00 |    T     |  4362.28 |  65.86 |
| aind-625749-lsb        | lsb12   | 1s    | blosc-lz4   | blosc-lz4-level_9-shuffle_byte-chunk1s   | 1.541 |   40.66 |   18.76 | 0.0000 |  0.0000 |      0.00 |    T     |  1010.29 | 103.41 |
| aind-625749-lsb        | lsb12   | 1s    | lz4         | lz4-acceleration_1-shuffle_byte-chunk1s  | 1.537 |   27.95 |    4.76 | 0.0000 |  0.0000 |      0.00 |    T     |  1452.35 | 103.51 |
| aind-634571-lsb        | lsb12   | 1s    | blosc-lz4   | blosc-lz4-level_9-shuffle_byte-chunk1s   | 1.522 |   41.16 |   18.59 | 0.0000 |  0.0000 |      0.00 |    T     |   989.05 | 103.48 |
| aind-634571-lsb        | lsb12   | 1s    | lz4         | lz4-acceleration_1-shuffle_byte-chunk1s  | 1.518 |   27.00 |    4.15 | 0.0000 |  0.0000 |      0.00 |    T     |  2071.74 | 103.72 |
| aind-634569-lsb        | lsb12   | 1s    | blosc-lz4   | blosc-lz4-level_9-shuffle_byte-chunk1s   | 1.434 |   32.75 |    4.36 | 0.0000 |  0.0000 |      0.00 |    T     |  1637.28 | 100.94 |
| aind-634569-lsb        | lsb12   | 1s    | lz4         | lz4-acceleration_1-shuffle_byte-chunk1s  | 1.430 |   20.56 |    8.28 | 0.0000 |  0.0000 |      0.00 |    T     |  1872.07 | 100.95 |
| aind-634568-lsb        | lsb12   | 1s    | blosc-lz4   | blosc-lz4-level_9-shuffle_byte-chunk1s   | 1.423 |   33.90 |    5.97 | 0.0000 |  0.0000 |      0.00 |    T     |  2828.26 | 102.61 |
| aind-634568-lsb        | lsb12   | 1s    | lz4         | lz4-acceleration_1-shuffle_byte-chunk1s  | 1.419 |   26.09 |    6.77 | 0.0000 |  0.0000 |      0.00 |    T     |  1304.96 | 102.70 |
| ibl-SWC054-probe00-raw | raw     | 1s    | blosc-lz4   | blosc-lz4-level_9-shuffle_byte-chunk1s   | 1.411 |   16.86 |   22.06 | 0.0000 |  0.0000 |      0.00 |    T     |   248.16 |  69.69 |
| ibl-SWC054-probe00-raw | raw     | 1s    | lz4         | lz4-acceleration_1-shuffle_byte-chunk1s  | 1.407 |   14.36 |   36.78 | 0.0000 |  0.0000 |      0.00 |    T     |   195.30 |  69.49 |
| ibl-CSHZAD029-raw      | raw     | 1s    | blosc-lz4   | blosc-lz4-level_9-shuffle_byte-chunk1s   | 1.377 |   30.50 |   43.87 | 0.0000 |  0.0000 |      0.00 |    T     |   165.45 |  70.21 |
| ibl-CSHZAD029-raw      | raw     | 1s    | lz4         | lz4-acceleration_1-shuffle_byte-chunk1s  | 1.373 |   25.22 |   36.82 | 0.0000 |  0.0000 |      0.00 |    T     |   161.14 |  69.66 |
| ibl-CSHZAD026-raw      | raw     | 1s    | blosc-lz4   | blosc-lz4-level_9-shuffle_byte-chunk1s   | 1.360 |   19.63 |   12.88 | 0.0000 |  0.0000 |      0.00 |    T     |   245.50 |  70.54 |
| ibl-CSHZAD026-raw      | raw     | 1s    | lz4         | lz4-acceleration_1-shuffle_byte-chunk1s  | 1.357 |   19.43 |    3.92 | 0.0000 |  0.0000 |      0.00 |    T     |   788.37 |  70.58 |
| ibl-SWC054-probe01-raw | raw     | 1s    | blosc-lz4   | blosc-lz4-level_9-shuffle_byte-chunk1s   | 1.352 |   34.82 |   25.33 | 0.0000 |  0.0000 |      0.00 |    T     |   160.47 |  70.49 |
| ibl-SWC054-probe01-raw | raw     | 1s    | lz4         | lz4-acceleration_1-shuffle_byte-chunk1s  | 1.349 |   25.08 |   35.14 | 0.0000 |  0.0000 |      0.00 |    T     |   161.54 |  70.64 |

## Median CR across 8 datasets

The paper reports distributions over its recording set; this is the comparable per-codec figure. `n` is the number of datasets contributing — a short `n` means cells are still missing or failed.

| preproc @ chunk | codec       | params                                   | median CR |   min |   max |   n |
| --------------- | ----------- | ---------------------------------------- | --------: | ----: | ----: | --: |
| lsb12 @ 1s      | lzma        | lzma-preset_9-shuffle_byte-chunk1s       |     2.708 | 2.662 | 2.821 |   4 |
| lsb12 @ 1s      | zstd        | zstd-level_22-shuffle_byte-chunk1s       |     2.629 | 2.566 | 2.738 |   4 |
| lsb12 @ 1s      | blosc-zstd  | blosc-zstd-level_9-shuffle_byte-chunk1s  |     2.577 | 2.554 | 2.666 |   4 |
| lsb12 @ 1s      | zlib        | zlib-level_9-shuffle_byte-chunk1s        |     2.494 | 2.468 | 2.579 |   4 |
| lsb12 @ 1s      | gzip        | gzip-level_9-shuffle_byte-chunk1s        |     2.494 | 2.468 | 2.579 |   4 |
| lsb12 @ 1s      | blosc-zlib  | blosc-zlib-level_9-shuffle_byte-chunk1s  |     2.490 | 2.464 | 2.576 |   4 |
| lsb12 @ 1s      | blosc-lz4hc | blosc-lz4hc-level_9-shuffle_byte-chunk1s |     1.842 | 1.811 | 1.916 |   4 |
| lsb12 @ 1s      | blosc-lz4   | blosc-lz4-level_9-shuffle_byte-chunk1s   |     1.478 | 1.423 | 1.541 |   4 |
| lsb12 @ 1s      | lz4         | lz4-acceleration_1-shuffle_byte-chunk1s  |     1.474 | 1.419 | 1.537 |   4 |
| raw @ 1s        | lzma        | lzma-preset_9-shuffle_byte-chunk1s       |     2.419 | 2.279 | 2.473 |   4 |
| raw @ 1s        | zstd        | zstd-level_22-shuffle_byte-chunk1s       |     2.319 | 2.175 | 2.342 |   4 |
| raw @ 1s        | blosc-zstd  | blosc-zstd-level_9-shuffle_byte-chunk1s  |     2.306 | 2.162 | 2.326 |   4 |
| raw @ 1s        | zlib        | zlib-level_9-shuffle_byte-chunk1s        |     2.238 | 2.115 | 2.254 |   4 |
| raw @ 1s        | gzip        | gzip-level_9-shuffle_byte-chunk1s        |     2.238 | 2.115 | 2.254 |   4 |
| raw @ 1s        | blosc-zlib  | blosc-zlib-level_9-shuffle_byte-chunk1s  |     2.234 | 2.112 | 2.251 |   4 |
| raw @ 1s        | blosc-lz4hc | blosc-lz4hc-level_9-shuffle_byte-chunk1s |     1.701 | 1.688 | 1.712 |   4 |
| raw @ 1s        | blosc-lz4   | blosc-lz4-level_9-shuffle_byte-chunk1s   |     1.368 | 1.352 | 1.411 |   4 |
| raw @ 1s        | lz4         | lz4-acceleration_1-shuffle_byte-chunk1s  |     1.365 | 1.349 | 1.407 |   4 |

## Highlights

- **Best lossless:** `lzma` (lzma-preset_9-shuffle_byte-chunk1s) — CR 2.821.
