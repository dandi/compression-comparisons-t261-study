# T.261 vs the paper codec set — compression (real NP1 recordings)

4 recordings (2 IBL, 2 AIND), 300 s slices, **both arms at 10 s chunks** so
every comparison is like-for-like. **All 96 cells.** 6 zstd cells were initially lost to an invalid `shuffle: bit`
(bit-shuffle is blosc-only) and were recovered by resuming the sweep in place.

Chunking is 10 s because the constraints push from both sides: numcodecs
rejects buffers over 1.97 GiB (so whole-buffer is impossible for every
non-T.261 arm), while T.261 costs ~20 s of compute per second of recording
and a 60 s chunk exceeded the encoder's subprocess timeout under load.

| codec      | mode     |   n | median CR | range         |
| ---------- | -------- | --: | --------: | ------------- |
| blosc-zstd | lossless |   6 |     2.516 | [2.04, 3.17]  |
| flac       | lossless |   6 |     2.534 | [1.91, 3.44]  |
| lzma       | lossless |   6 |     2.476 | [2.08, 2.83]  |
| t261       | lossless |   6 |     3.563 | [2.01, 3.80]  |
| t261       | lossy    |  30 |     4.551 | [2.06, 16.80] |
| wavpack    | lossless |   7 |     3.595 | [2.00, 3.67]  |
| wavpack    | lossy    |  29 |     5.507 | [2.64, 7.16]  |
| zstd       | lossless |   6 |     2.346 | [1.92, 2.80]  |

## Reading

* **On lossless, T.261 (3.563) and WavPack (3.595) tie and both clearly beat
  the general-purpose set** -- `lzma`, the paper's best lossless codec, reaches
  only 2.476. A ~44 % advantage for the domain-specific codecs on real data.
* On lossy the two occupy different regimes: WavPack's hybrid mode tops out at
  CR 7.16, while T.261 spans to 16.80. Whether that headroom is usable is the
  sorting question, answered in `sorting-fidelity-600s.md`.
