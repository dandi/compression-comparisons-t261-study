# Phase 1 gate — reproduction of Buccino et al. 2023 (Fig 2/6)

9 general-purpose codecs x 8 NP1 recordings = 72 cells, paired
**per recording** against the capsule's own per-session numbers
(`benchmark-lossless.csv`, 6300 rows), at the paper's conditions: level
`high`, shuffle `byte`, 1 s chunks, LSB-corrected.

`byte` is forced, not chosen: the reference has no `bit` rows for the
non-blosc codecs, so it is the only shuffle present for all nine.

## Verdict: PASS

**Deviation from the paper, per recording: median 0.02 %, max 1.16 %.**

Gate thresholds are median <= 2 % and max <= 5 %. The median is inside by
roughly two orders of magnitude and the worst single cell by a factor of ~4.

| codec       |   n | median deviation | max deviation |
| ----------- | --: | ---------------: | ------------: |
| zstd        |   8 |           0.32 % |        1.16 % |
| blosc-zstd  |   8 |           0.15 % |        0.71 % |
| lz4         |   8 |           0.03 % |        0.05 % |
| blosc-lz4   |   8 |           0.02 % |        0.04 % |
| lzma        |   8 |           0.02 % |        0.02 % |
| blosc-lz4hc |   8 |           0.01 % |        0.02 % |
| zlib        |   8 |           0.01 % |        0.02 % |
| gzip        |   8 |           0.01 % |        0.02 % |
| blosc-zlib  |   8 |           0.01 % |        0.11 % |

## Ranking

Both rankings are computed from the same 8 recordings at the same
conditions -- ours from our cells, the paper's from its own per-session rows.

* ours : lzma > zstd > blosc-zstd > zlib > gzip > blosc-zlib > blosc-lz4hc > blosc-lz4 > lz4
* paper: lzma > zstd > blosc-zstd > gzip > zlib > blosc-zlib > blosc-lz4hc > blosc-lz4 > lz4
* identical positions: 7/9

| codec       | our median CR | paper median CR |
| ----------- | ------------: | --------------: |
| lzma        |        2.5674 |          2.5675 |
| zstd        |        2.4540 |          2.4635 |
| blosc-zstd  |        2.4404 |          2.4370 |
| gzip        |        2.3614 |          2.3610 |
| zlib        |        2.3614 |          2.3610 |
| blosc-zlib  |        2.3574 |          2.3575 |
| blosc-lz4hc |        1.7616 |          1.7615 |
| blosc-lz4   |        1.4170 |          1.4170 |
| lz4         |        1.4132 |          1.4130 |

The single disagreement is `gzip` vs `zlib`, and they are **tied**:
2.3610 vs 2.3610 in the paper's own data,
2.3614 vs 2.3614 in ours. The paper writes them as
"gzip = zlib". Ordering a tie differently is not a reproduction failure, so
the ranking is reproduced as exactly as the data permits.

## Corrections to the first version of this report

Recorded because both errors ran in the same direction -- understating a
result -- and because the cause is worth not repeating.

1. It stated that *"the paper publishes only medians, so a per-recording
   pairing against them is not available"*. False. `benchmark-lossless.csv`
   is per-session and was in the vendored capsule the whole time. A derived
   table of medians and ranges was built from it early on, and every later
   comparison used that derived table instead of the source.
2. It reported *median 5.0 % / max 11.7 %* against the 2 %/5 % thresholds,
   from comparing single recordings against a median over eight. That
   statistic measures per-recording spread, not reproduction error.
3. It reported the ranking matching at 5/9. On identical footing it is
   7/9, with the only gap being a tie.
