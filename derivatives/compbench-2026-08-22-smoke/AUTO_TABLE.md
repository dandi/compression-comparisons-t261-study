# Sweep report

**Cells:** 3 total (3 lossless + 0 lossy).

Auto-rendered post-sweep.

| dataset | preproc | chunk | codec | params | CR | enc xRT | dec xRT | RMSE | RMSE_bp | PRDN/ch % | lossless | wall_s | RSS GB |
| --- | --- | --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | :---: | ---: | ---: |
| synthetic-tiny | raw | whole | t261 | t261-a8b86fcf | 1.590 | 30.55 | 61.76 | 0.0000 | — | 0.00 | T | 0.60 | 0.01 |
| synthetic-tiny | raw | whole | blosc-zstd | blosc-zstd-level_5-shuffle_bit | 1.536 | 647.34 | 4353.90 | 0.0000 | — | 0.00 | T | 0.54 | 0.01 |
| synthetic-tiny | raw | whole | blosc-zstd | blosc-zstd-level_3-shuffle_byte | 1.514 | 680.96 | 4484.09 | 0.0000 | — | 0.00 | T | 0.57 | 0.01 |

## Highlights

- **Best lossless:** `t261` (t261-a8b86fcf) — CR 1.590.
