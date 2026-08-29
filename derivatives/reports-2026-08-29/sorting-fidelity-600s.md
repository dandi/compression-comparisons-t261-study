# T.261 vs the paper codec set — sorting fidelity (MEArec NP1, 600 s)

**Arms:** 17 complete.

Kilosort 4 against MEArec ground truth on the FULL recording, as the paper uses it. A 100 s slice was run first and is superseded: its depressed baseline (87 of 100 units vs 96 here) reversed the sign of several lossy comparisons.

Unit counts first, deliberately: `accuracy` is pooled over matched units and can rise while the sorting degrades. The lossless arms are the baseline, not a target -- a sorter recovers ground truth imperfectly even on untouched data.

| arm                |       CR | well detected | false positive | redundant | accuracy | vs baseline       |
| ------------------ | -------: | ------------: | -------------: | --------: | -------: | ----------------- |
| blosc-zstd level 9 |    2.933 |            96 |            126 |        23 |   0.9809 | +0 well, +0 FP    |
| bittrunc 0 bits    |    3.347 |            96 |            126 |        23 |   0.9809 | baseline          |
| t261 lossless      |    3.721 |            96 |            126 |        23 |   0.9809 | +0 well, +0 FP    |
| wavpack 6.0 bps    |    3.734 |            96 |            126 |        23 |   0.9809 | +0 well, +0 FP    |
| t261 QP 1.5        |    4.270 |            94 |            129 |        26 |   0.9581 | -2 well, +3 FP    |
| wavpack 4.0 bps    |    4.450 |            97 |            143 |        23 |   0.9859 | +1 well, +17 FP   |
| t261 QP 2.0        |    4.829 |            98 |            133 |        26 |   0.9863 | +2 well, +7 FP    |
| wavpack 3.0 bps    |    5.759 |            94 |            128 |        22 |   0.9670 | -2 well, +2 FP    |
| t261 QP 3.0        |    5.989 |            98 |            138 |        22 |   0.9862 | +2 well, +12 FP   |
| wavpack 2.5 bps    |    6.746 |            95 |            135 |        24 |   0.9740 | -1 well, +9 FP    |
| wavpack 2.25 bps   |    7.101 |            97 |            131 |        24 |   0.9818 | +1 well, +5 FP    |
| t261 QP 5.0        |    8.575 |            96 |            145 |        30 |   0.9734 | +0 well, +19 FP   |
| t261 QP 8.0        |   14.514 |            99 |            184 |        23 |   0.9891 | +3 well, +58 FP   |
| bittrunc 4 bits    |   29.098 |           100 |            353 |        37 |   0.9946 | +4 well, +227 FP  |
| bittrunc 5 bits    |  337.411 |            77 |            923 |       303 |   0.8467 | -19 well, +797 FP |
| bittrunc 6 bits    | 1939.651 |            20 |            644 |       194 |   0.3856 | -76 well, +518 FP |
| bittrunc 7 bits    | 4884.255 |             4 |            588 |        44 |   0.1215 | -92 well, +462 FP |

## Null control

4 lossless arms, accuracy spread **0.000000**. A spread of zero means the sorter is deterministic on this input, so any difference a lossy arm shows is attributable to the codec rather than to run-to-run variability.
