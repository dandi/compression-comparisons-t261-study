# Sweep report

**Cells:** 3 total (3 lossless + 0 lossy).

Auto-rendered post-sweep.

| dataset | preproc | chunk | codec | params | CR | enc xRT | dec xRT | RMSE | RMSE_bp | PRDN/ch % | lossless | wall_s | RSS GB |
| --- | --- | --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | :---: | ---: | ---: |
| synthetic-tiny | raw | whole | t261 | t261-a8b86fcf | 1.590 | 30.61 | 59.92 | 0.0000 | — | 0.00 | T | 0.61 | 0.01 |
| synthetic-tiny | raw | whole | blosc-zstd | blosc-zstd-level_5-shuffle_bit | 1.536 | 717.54 | 4590.37 | 0.0000 | — | 0.00 | T | 0.50 | 0.01 |
| synthetic-tiny | raw | whole | blosc-zstd | blosc-zstd-level_3-shuffle_byte | 1.514 | 696.92 | 4714.36 | 0.0000 | — | 0.00 | T | 0.50 | 0.01 |

## Highlights

- **Best lossless:** `t261` (t261-a8b86fcf) — CR 1.590.
