# Results, 2026-08-29

Four reports from three completed sweeps. Each states its own conditions and
caveats; this is the map.

| report | what it answers |
| ------ | --------------- |
| `phase1-gate.md` | Do we reproduce Buccino et al.'s lossless compression ratios? |
| `t261-vs-paper-compression.md` | How does T.261 compare on compression alone, real recordings? |
| `sorting-fidelity-600s.md` | What does lossy compression do to the spike trains a sorter recovers? |
| `waveform-fig14.md` | Does each codec meet the paper's only stated numeric tolerance? |

## The short version

**Reproduction succeeds.** Seven of nine codecs match the paper's median CR to
three decimal places, largest deviation 0.4 %.

**T.261 and WavPack Hybrid are a genuine trade, not a winner.** At their best
operating points: WavPack 2.25 bps gives CR 7.10 with +5 false-positive units;
T.261 QP 5.0 gives CR 8.58 with +19, both at lossless-parity unit recovery and
both inside the paper's waveform tolerance. T.261 compresses ~21 % harder;
WavPack keeps the detector quieter.

**T.261's one clear structural advantage is predictability.** Its false
positives rise monotonically with QP (129 -> 133 -> 138 -> 145 -> 184) while
WavPack's scatter with no trend (126 -> 143 -> 128 -> 135 -> 131). WavPack's
scatter is also the honest error bar on both codecs: differences smaller than
~17 false positives at a single matched CR are not resolvable from one
recording.

**On lossless, T.261 is strong** -- CR 3.72 vs blosc-zstd's 2.93 on simulated
data, and tied with WavPack on real recordings, both ~44 % ahead of `lzma`.

## Two methodological warnings

**Never lead with `accuracy`.** It is pooled over matched units and rises while
sorting degrades. `bittrunc 4 bits` posts the highest accuracy in the study
(0.9946) and 100/100 units detected -- alongside 353 false positives against a
baseline of 126. It is the setting the paper explicitly rejects.

**Judge distributions, not maxima.** Scoring Fig 14 on the maximum per-unit
error reported that WavPack 2.25 bps FAILS the paper's own criterion, which the
paper states it meets. One ill-conditioned unit sets the max. p90 is used
throughout.

## What is not here

* The 100 s sorting run is superseded and deliberately excluded: its depressed
  baseline (87 of 100 units vs 96) reversed the sign of several lossy
  comparisons.
* One simulated recording underlies all sorting results. Real-recording
  sorting is not yet run.
* 6 zstd cells of the compression comparison are queued to re-run.
* The 912-cell exhaustive reproduction sweep is paused at 174, tagged
  `reproduction-174-cells`.
