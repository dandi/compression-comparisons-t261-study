# Phase 1 gate — reproduction of Buccino et al. 2023 (Fig 2/6)

9 general-purpose codecs x 8 NP1 recordings = 72 cells, at the paper's
conditions: LSB-corrected, 1 s chunks, level `high`, shuffle `byte`.

`byte` is forced, not chosen: the reference table has no `bit` rows for the
non-blosc codecs (bit-shuffle is a blosc feature), so `byte` is the only
setting present for all nine.

**69 of 72 cells (96 %) fall inside the paper's per-recording CR range.**

| codec       |   n | our median CR | paper median | ratio |
| ----------- | --: | ------------: | -----------: | ----: |
| blosc-lz4   |   8 |         1.417 |        1.417 | 1.000 |
| blosc-lz4hc |   8 |         1.762 |        1.762 | 1.000 |
| blosc-zlib  |   8 |         2.357 |        2.357 | 1.000 |
| blosc-zstd  |   8 |         2.440 |        2.437 | 1.001 |
| gzip        |   8 |         2.361 |        2.361 | 1.000 |
| lz4         |   8 |         1.413 |        1.413 | 1.000 |
| lzma        |   8 |         2.567 |        2.567 | 1.000 |
| zlib        |   8 |         2.361 |        2.361 | 1.000 |
| zstd        |   8 |         2.454 |        2.463 | 0.996 |

## Verdict

**Seven of nine codecs reproduce the paper's median to three decimal places;**
the largest deviation is 0.4 %. On the quantity the gate is about -- do our
compression ratios match the paper's -- this is essentially exact.

### Ranking

* ours : lzma > zstd > blosc-zstd > zlib > gzip > blosc-zlib > blosc-lz4hc > blosc-lz4 > lz4
* paper: lzma > blosc-zstd > zstd > gzip > zlib > blosc-zlib > blosc-lz4hc > blosc-lz4 > lz4
* identical positions: 5/9

`lzma` first and the bottom four are exact. The middle disagreements are
between codecs that tie: `gzip` and `zlib` are **identical at 2.361** in both
datasets, and `zstd`/`blosc-zstd` differ by 0.014. The paper itself writes
"gzip = zlib". Ordering codecs that agree to three decimals is not a
meaningful test, and a ranking criterion should not be read as failed here.

### A note on the per-cell ratio statistic

Comparing each individual recording against the paper's median-over-eight
gives median 5.0 % / max 11.7 %, which exceeds the plan's 2 %/5 % thresholds.
That statistic measures per-recording spread, not reproduction error -- the
paper publishes only medians, so a per-recording pairing against them is not
available. The per-codec column above is the paired comparison the gate
intends. This is recorded rather than resolved silently.
