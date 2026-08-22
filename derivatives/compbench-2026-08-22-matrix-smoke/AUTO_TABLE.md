# Sweep report

**Cells:** 3 total (3 lossless + 0 lossy).

Auto-rendered post-sweep.

| dataset | preproc | chunk | codec | params | CR | enc xRT | dec xRT | RMSE | RMSE_bp | PRDN/ch % | lossless | wall_s | RSS GB |
| --- | --- | --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | :---: | ---: | ---: |
| aind-625749-lsb | lsb12 | 1s | blosc-zstd | blosc-zstd-level_9-shuffle_bit-chunk1s | 3.166 | 0.52 | 50.83 | 0.0000 | 0.0000 | 0.00 | T | 12.68 | 1.10 |
| ibl-CSHZAD026-raw | raw | 1s | blosc-zstd | blosc-zstd-level_9-shuffle_bit-chunk1s | 2.544 | 0.69 | 38.60 | 0.0000 | 0.0000 | 0.00 | T | 8.25 | 0.42 |
| aind-625749-raw | raw | 1s | blosc-zstd | blosc-zstd-level_9-shuffle_bit-chunk1s | 2.109 | 0.39 | 36.18 | 0.0000 | 0.0000 | 0.00 | T | 13.85 | 0.31 |

## Median CR across 3 datasets

The paper reports distributions over its recording set; this is the comparable per-codec figure. `n` is the number of datasets contributing — a short `n` means cells are still missing or failed.

| preproc @ chunk | codec | params | median CR | min | max | n |
| --- | --- | --- | ---: | ---: | ---: | ---: |
| lsb12 @ 1s | blosc-zstd | blosc-zstd-level_9-shuffle_bit-chunk1s | 3.166 | 3.166 | 3.166 | 1 |
| raw @ 1s | blosc-zstd | blosc-zstd-level_9-shuffle_bit-chunk1s | 2.327 | 2.109 | 2.544 | 2 |

## Highlights

- **Best lossless:** `blosc-zstd` (blosc-zstd-level_9-shuffle_bit-chunk1s) — CR 3.166.
