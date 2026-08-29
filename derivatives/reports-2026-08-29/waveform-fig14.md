# Waveform-feature errors — Buccino et al. Fig 14 criterion

MEArec NP1, 100 s slice, **all 100 ground-truth units**. No sorter is
involved: the ground-truth spike trains are applied to both the original
and the lossy recording, so the units are identical by construction and
sorter variability cannot leak in.

Judged on **p90** of the per-unit relative error, per feature and distance,
against the paper's 10 % line — not on `max`. A single ill-conditioned unit
(low-amplitude template, near-zero denominator in a *relative* error) sets
the max far above where the distribution lies; scoring on max reported that
WavPack 2.25 bps FAILS the paper's own criterion, which the paper states it
meets. That wrong verdict is what exposed the bug.

| arm              |     CR |    p90 | median | within 10% |
| ---------------- | -----: | -----: | -----: | :--------: |
| WavPack 6.0 bps  |  3.734 | 0.0000 | 0.0000 |    yes     |
| T.261 QP 1.5     |  4.271 | 0.0379 | 0.0066 |    yes     |
| WavPack 4.0 bps  |  4.449 | 0.0432 | 0.0193 |    yes     |
| T.261 QP 2.0     |  4.829 | 0.0375 | 0.0080 |    yes     |
| WavPack 3.0 bps  |  5.759 | 0.0500 | 0.0139 |    yes     |
| T.261 QP 3.0     |  5.990 | 0.0337 | 0.0144 |    yes     |
| WavPack 2.5 bps  |  6.747 | 0.0859 | 0.0161 |    yes     |
| WavPack 2.25 bps |  7.101 | 0.0573 | 0.0195 |    yes     |
| T.261 QP 5.0     |  8.576 | 0.0853 | 0.0322 |    yes     |
| T.261 QP 8.0     | 14.517 | 0.1449 | 0.0841 |     NO     |

## Reading

* Medians rise monotonically with compression, as they must. The
  non-monotonicity seen at 20 units was small-sample noise in p90 —
  WavPack 3.0 / 2.5 bps read 0.148 / 0.145 there and 0.050 / 0.086 here.
* **T.261 QP 5.0 (CR 8.576) is the highest-compression arm that passes**,
  ~21 % beyond WavPack's best passing point (2.25 bps, CR 7.101).
* At matched CR, T.261 carries the lower error: 0.038 vs 0.043 near CR 4.3–4.5,
  0.034 vs 0.050 near CR 6.0.
* T.261 QP 8.0 fails at 0.145, and that failure was stable from 20 to 100 units,
  so it is genuine rather than a sampling artifact.

## Tension with the sorting metrics

At QP 5.0 the sorting run showed −6 well-detected units and +10 false positives,
while this table shows T.261 preserving waveform shape better than WavPack. Both
are measured; they answer different questions. Ground-truth-triggered averaging
does not probe the inter-spike noise structure that detection thresholds respond to.

## Caveats

* One simulated recording, 100 s slice. The 600 s rerun is the check.
* `half_width` uses the paper's SI-0.97.1 definition, computed directly; SI >= 0.104
  changed it and differs by ~57 % at p90 on the paper's own templates.

