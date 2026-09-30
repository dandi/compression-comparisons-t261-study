# Public comment on DICOM Supplement 253 (Waveform Compression)

**Draft — not yet submitted.** Tracks
[dandi/compression-comparisons-t261-study#1](https://github.com/dandi/compression-comparisons-t261-study/issues/1).
Due 2026-11-04, 23:59 US Eastern, to Shayna Knazik <sknazik@dicomstandard.org>.

* **Document:** Supplement 253: Waveform Compression, Version 09, 2026-09-18,
  Public Comment (`sup253_pc_WaveformCompressions.pdf`)
* **Commenter:** Yaroslav O. Halchenko, Dartmouth College; DANDI Archive
  (<yaroslav.o.halchenko@dartmouth.edu>)
* **Co-signers:** _TBD_

Line numbers are those printed in the PDF margin; page numbers are the
document's own ("Page N" in the header). The Open and Closed Issues pages
carry no line numbers, so those are cited by issue number.

## Summary

We run the DANDI Archive, the NIH BRAIN Initiative archive for
neurophysiology. It holds a large and growing volume of extracellular
microelectrode recordings. These are sampled at ~30 kHz on hundreds of
channels per probe, which puts them at the far end of the envelope the
Supplement describes: a single Neuropixels probe produces 23 MB/s, or
~83 GB per hour, uncompressed. Microelectrode recordings are also clinical
data: intraoperative microelectrode recording (MER) during deep brain
stimulation surgery, and intracortical brain-computer interface trials.

We welcome a standardized, lossless-capable waveform codec in DICOM, and we
benchmarked T.261 independently on this class of data. The comparison set
and protocol follow Buccino et al. 2023 (J Neural Eng,
[10.1088/1741-2552/acf5a4](https://doi.org/10.1088/1741-2552/acf5a4)). As a
check, we reproduced that paper's lossless results for its nine
general-purpose codecs on eight recordings, to within 0.02 % median and
1.16 % maximum deviation per recording. The main findings that bear on the
Supplement:

1. **T.261 compresses these recordings well in its independent-channel
   configuration, the only one we could run.** Its lossless median CR of
   3.56 ties WavPack (3.56) and is ~42 % ahead of the best general-purpose
   codec (`blosc-zstd`, 2.52). The joint-channel configuration, the only
   one Closed Issue #10 admits, did not finish encoding 10 s of 384-channel
   data within 30 minutes.
2. **The reference software runs 5–50x slower than real time.** Decoding
   alone took ~5 s of wall-clock time per second of recording,
   single-threaded, for lossless and lossy alike.
3. **Compression ratio alone does not describe lossy fidelity.** For T.261,
   the quantizer step fixes the error, and CR follows from the data. The
   same recording, stored at two scalings, gave CR 3.1 and 12.1 at the same
   step.
4. **At moderate settings, lossy T.261 preserved spike sorting and spike
   waveforms.** Up to QP 5.0 (CR 8.6), unit recovery stayed within two
   units of lossless, and waveform features stayed within a 10 %
   tolerance. Spurious units rose steadily with QP. QP 8.0 failed the
   waveform test.

Details, evidence and caveats follow the comments.

## Comments

### Comment 1 (technical, major): the lossless Transfer Syntax should not exclude independent-channel coding

**Where:** Closed Issue #10 (p. 8); A.X.1, lines 540–550.

**Comment.** Closed Issue #10 settles on a single lossless Transfer Syntax
using "joint channels". It dismisses "individual channels" because it "is
expected to result in little compression ratio". On 384-channel, 30 kHz
microelectrode recordings, our experience was the reverse:

* Independent-channel lossless T.261
  (`combinedPresetEEG_IndepChannel_lossless`) reached a median CR of 3.56 on
  six inputs (four recordings, see Evidence). That ties WavPack (3.56) and
  beats every general-purpose codec we tested (`blosc-zstd` 2.52, `lzma`
  2.48, `zstd` 2.35).
* Joint-channel lossless T.261 (`combinedPresetEEG_lossless`), tried on a
  10 s, 384-channel excerpt of one recording, did not finish encoding
  within our 30-minute limit. That is more than 180x slower than real
  time. If cost scaled linearly, a 1–2 h recording would need at least
  several days per probe. We therefore have no joint-channel compression
  ratio for this data. It may well be good, but we could not obtain it.

If the Transfer Syntax, or conformance to it, requires joint-channel
coding, T.261 is not usable in practice for high-channel-count
microelectrode data. We understand that the channel-group configuration is
signalled in the bitstream (CGP_SPT, a required stream packet, line 557),
so any conformant decoder handles either grouping. Excluding
independent-channel coding therefore buys no decoder simplicity; it only
removes the encoder configuration that works for this modality.

**Proposed solution.** Reopen Closed Issue #10. In A.X.1, state explicitly
that the lossless and lossy Transfer Syntaxes do not constrain the
channel-group configuration. Joint, independent, or any partition of a
Multiplex Group's channels into channel groups should be permitted, as
signalled by the CGP_SPT stream packets. If WG-06 prefers a single
recommended default, put it in an informative note, not in the Transfer
Syntax definition.

### Comment 2 (technical): computational cost at high channel count and sampling rate

**Where:** Closed Issue #1 (p. 7); Closed Issue #2 (p. 7).

**Comment.** Closed Issue #1 frames suitability only in terms of the
compression achieved. For microelectrode data, throughput matters as much.
We measured the reference software (`vceg-sw/bwc`, which Closed Issue #2
points implementers to) on 384-channel, 30 kHz data. Figures are
wall-clock, single-threaded:

| codec (mode)          | encode, x real time | decode, x real time |
| --------------------- | ------------------: | ------------------: |
| T.261 lossless        |               0.080 |                0.21 |
| T.261 lossy           |               0.019 |                0.20 |
| WavPack lossless      |                2.97 |                3.34 |
| WavPack hybrid lossy  |                1.38 |                2.49 |
| FLAC lossless         |                3.99 |                5.93 |
| blosc-zstd (level 9)  |                0.32 |               25.64 |

Values below 1 are slower than real time. At 0.21x decode, simply reading
back one hour of one probe takes ~5 hours. Viewers, analysis software, and
any archive that serves decompressed data all pay this cost.

These figures carry caveats (see Caveats). The encoder was driven through
files, on a host shared with other jobs, so the ratios between codecs are
more trustworthy than the absolute values. Even so, T.261 is ~12–70x
slower than WavPack, which compresses this data equally well, and its
decoder runs at a fifth of real time.

**Proposed solution.** We ask WG-32 to publish throughput figures for the
reference software at high channel counts and sampling rates. We also ask
that the Supplement state that T.261 decode cost scales with channel count
× sampling rate, so implementers of archives and viewers can plan for it.
If parallel decoding by channel group is what makes this practical, that
argues again for Comment 1.

### Comment 3 (technical): 1024-channel limit in Table 8.3.1-1

**Where:** Section 8.3.1, Table 8.3.1-1, lines 436–439; Closed Issue #16
(pp. 8–9).

**Comment.** Table 8.3.1-1 caps Number of Channels at 1024 for every sample
interpretation. It is not stated whether this is a limit of T.261 or a
DICOM choice; the Scope (lines 107–108) says T.261 supports "large numbers
of channels".

Single recording devices already exceed 1024 channels digitized
synchronously at one sampling rate, i.e. a single Multiplex Group. One
example is CMOS high-density microelectrode arrays with 4096 simultaneously
sampled electrodes. Implantable brain-computer interfaces are approaching
and reaching this scale.

Closed Issue #16 records that "WG-32 is not aware of any use cases for EEG
nor ECG which require more than one Multiplex Group". High-density
microelectrode recording would be such a use case if the cap stays, since
its data would have to be split across groups.

**Proposed solution.** State the origin of the 1024 limit. If it is not a
T.261 constraint, raise it (e.g. to 65535, the range of Number of Waveform
Channels (003A,0005), VR US) or remove it. If it is a T.261 constraint, add
a note that larger arrays must be split across Multiplex Groups. Reopen
Closed Issue #16 to include high-density microelectrode recording.

### Comment 4 (technical, major): convey the quantizer step, not only the compression ratio (answer to Open Issue #21)

**Where:** Open Issue #21 (p. 6); Closed Issue #4 (p. 7); C.10.9.1.X2.2,
lines 219–229; Open Issue #23 (p. 6).

**Comment.** Lossy Waveform Compression Ratio is the only fidelity
indicator the Supplement records. For T.261 it is a poor one. T.261's
quantizer step (`StepSizeForQP`) sets the reconstruction error directly,
in stored sample units. Across all six inputs, the RMSE at a given step
varied by at most ~15 %, and by under 1 % at QP 8.0 on the four LSB = 1
inputs. The CR is then whatever the data yield.

Across our four recordings (LSB = 1), CR at a fixed step varied by 1.1–1.4x.
The larger effect is sample scaling. Two of the recordings are stored by
their acquisition software as multiples of 12 (see Comment 6). On the same
recording, the same step gave:

| input                            | QP 1.5 CR | QP 8.0 CR | RMSE at QP 8.0 (stored units) |
| -------------------------------- | --------: | --------: | ----------------------------: |
| AIND 625749, as stored (×12)     |      2.06 |      3.07 |                          2.11 |
| AIND 625749, LSB-corrected       |      4.00 |     12.07 |                          2.42 |
| four recordings, LSB = 1 (range) | 4.00–4.40 | 12.1–16.8 |                     2.42–2.44 |

In other words, QP 8.0 on data as stored produced a lower CR (3.1) than
QP 1.5 on the LSB-corrected data (4.0–4.4). Measured in ADC counts, however,
its error was about 12x smaller. The CR alone cannot distinguish these
cases; the quantizer step, read together with Channel Sensitivity, can.

The step also tracked the downstream effect. In our spike-sorting
evaluation (Comment 5), spurious units rose monotonically with QP:
129 → 133 → 138 → 145 → 184 for QP 1.5 → 8.0.

Closed Issue #4 decided that parameters used internally by the codec should
not be duplicated into DICOM metadata. We think the quantizer step is
different. It is not an internal detail: it is the fidelity contract of the
lossy encoding, and it is needed for querying (Open Issue #23) without
parsing the bitstream.

**Proposed solution.** Answer Open Issue #21 affirmatively. Add a
multi-valued attribute for the T.261 quantization step size, parallel to
Lossy Waveform Compression Method (ggg1,eee2). If per-block QP variation is
enabled, record the maximum step. Where the encoder enables them, also
record the maximum absolute error (MAE) and SNR quality indicators. Note
that the step is in stored units, so it is interpreted via Channel
Sensitivity (003A,0210). Require Lossy Waveform Compression Ratio to be the
measured value rather than a nominal estimate (lines 226–228), because
T.261 has no nominal CR to supply. For Open Issue #23, make the step
available as a Repository Query key alongside the CR.

### Comment 5 (informative): lossy suitability evidence for extracellular recordings

**Where:** Section 8.3.1, Note, lines 424–428.

**Comment.** We agree that clinical acceptability is out of the Standard's
scope. We offer evidence in case it helps WG-32 or implementers. Setup:
a simulated Neuropixels 1.0 recording (MEArec, 100 ground-truth units,
600 s), sorted with Kilosort 4.

| arm               |     CR | well detected | false positive | waveform p90 err |
| ----------------- | -----: | ------------: | -------------: | ---------------: |
| lossless baseline |  3.721 |            96 |            126 |          0.000 ¹ |
| T.261 QP 1.5      |  4.270 |            94 |            129 |            0.038 |
| T.261 QP 3.0      |  5.989 |            98 |            138 |            0.034 |
| T.261 QP 5.0      |  8.575 |            96 |            145 |            0.085 |
| T.261 QP 8.0      | 14.514 |            99 |            184 |            0.145 |
| WavPack 2.25 bps  |  7.101 |            97 |            131 |            0.057 |

¹ Zero by construction for a lossless codec.

"Waveform p90 err" is the 90th percentile, over units, of the relative
error in spike-waveform features. We apply the 10 % tolerance of Buccino et
al. (Fig. 14). It is computed from ground-truth spike times, so no sorter
is involved, on a 100 s excerpt of the same recording.

Through QP 5.0, T.261 kept unit recovery within two units of lossless and
passed the waveform criterion, at ~21 % higher CR than WavPack's best
passing setting. It produced more spurious units than WavPack there
(+19 vs +5), but that gap is within what one recording can resolve (see
Caveats). QP 8.0 fails the waveform criterion. The practical lesson for this
modality is to choose the quantizer by its effect on spike detection, not by
CR, which again supports Comment 4.

**Proposed solution.** No normative change. Optionally, add to the Note
that the suitability of a given lossy setting depends on the downstream
analysis and should be established per modality.

### Comment 6 (technical): integer scale factors defeat lossless compression; guidance for producers

**Where:** Section 8.3.1, lines 429–432.

**Comment.** Some acquisition software rescales samples to a fixed physical
unit before storing them. Open Ephys, for example, rescales to
0.195 µV/bit, so Neuropixels 1.0 data are stored as exact multiples of 12
(Buccino et al. 2023, §2.2.1). The low log2(12) ≈ 3.6 bits then carry no
information, and neither T.261 nor WavPack exploited this in our tests. On
the same two recordings, lossless T.261 reached CR 2.01 / 2.08 as stored,
and 3.53 / 3.65 once each channel was re-expressed with an LSB of 1
(median removed, then divided by 12): ~75 % better. No existing attribute
can signal that samples lie on a coarser grid than their bit depth
implies.

**Proposed solution.** Add an informative note recommending that producers
store sample values in native ADC counts (LSB = 1). The physical scaling
belongs in Channel Sensitivity (003A,0210) and Channel Sensitivity
Correction Factor (003A,0212), which already exist for this purpose. We
also suggest to ITU-T that a future T.261 revision detect and signal a
common integer scale factor per channel, in the spirit of FLAC's "wasted
bits" but not limited to powers of two.

### Comment 7 (technical): stream sizes exceed 32-bit offsets within minutes

**Where:** A.X, lines 528–535 (Basic Offset Table); Closed Issue #15
(p. 8); Closed Issue #18 (p. 9); Open Issue #22 (p. 6).

**Comment.** Closed Issue #15 itself anticipates "long running recordings
with high resolutions, which would require 64 bit pointers". For
microelectrode data, those recordings are the norm:

* One 384-channel, 30 kHz, 16-bit probe passes 2^32 bytes after ~3 minutes
  uncompressed, and its compressed stream does so after ~11 minutes at
  CR 3.5.
* Recordings of 1–2 hours are routine.

Closed Issue #15 concludes that T.261's internal index makes an offset
table unnecessary. But A.X still permits a non-empty Basic Offset Table of
32-bit offsets, and such a table would overflow on this data.

The same size limit applies to the native format: one probe exceeds what
a single Waveform Data element can hold in the Default Transfer Syntax
after ~3 minutes. So for this modality the waiver in Section 10.1
(lines 452–455) is the norm rather than the exception, and receivers
effectively must support the compressed Transfer Syntax. That makes
Comments 1 and 2 more pressing.

**Proposed solution.**

* Either require the Basic Offset Table to be empty for T.261 Transfer
  Syntaxes, deferring random access to T.261's own index, or define a
  64-bit offset table for waveforms analogous to Extended Offset Table
  (7FE0,0001) for Pixel Data.
* Answer Open Issue #22 affirmatively. A DICOMweb mechanism to retrieve a
  time range of a waveform, analogous to frame retrieval, would be widely
  used for this data.

### Comment 8 (general): rationale for excluding other codecs should be scoped to the modalities evaluated

**Where:** Closed Issue #1 (p. 7); Closed Issue #17 (p. 9).

**Comment.** Closed Issue #1 states that standardized audio codecs "did not
produce a sufficient result". On microelectrode data, WavPack, an open
audio codec, matched T.261 lossless (CR 3.56 vs 3.56). It was also about
12–70x faster (Comment 2). It is the codec Buccino et al. identified as
the best-performing for this modality.

FLAC reached only 2.53 here, so we do not argue for FLAC on merit. However,
the stated reason for not evaluating it ("only supports up to 8 channels")
is a per-stream limit. It does not preclude coding a Multiplex Group as
several streams.

**Proposed solution.** Scope the answer to Closed Issue #1 to the
modalities actually evaluated, and publish or cite that evaluation. Revise
the FLAC rationale in Closed Issue #17 accordingly. We do not propose
adding either codec to this Supplement. We only ask that the record not
imply evidence that does not extend to all waveform modalities.

### Comment 9 (general): patent status

**Where:** Open Issue #3 (p. 6).

**Comment.** The reference software's Clear BSD license explicitly grants no
patent rights, and Open Issue #3 records that no patent declarations have
been filed. Open-science archives such as DANDI, and the open-source tools
that read their data, can adopt a format only if implementations can be
freely redistributed.

**Proposed solution.** Before final text, obtain royalty-free declarations
from the T.261 contributors (or confirmation that none are required), and
record the outcome in the Supplement.

### Comment 10 (editorial)

**Where and proposed correction:**

* A.X, lines 501 and 519: "Waveform Data (5400,0010)" → (5400,1010).
* Line 231: "(ggge1,eee2)" → (ggg1,eee2).
* Line 415: "one ore more" → "one or more".
* Table N.5-70 (p. 12, lines 131–133): the lossy row is named "T.261
  Transfer Syntax for Lossless Waveform Compression" and uses the
  placeholder "UID_TS1_lossy" (elsewhere "UID_TS2_lossy").

## Evidence

All numbers above come from an open, reproducible benchmark:

* Tool: [dandi/compression-comparisons](https://github.com/dandi/compression-comparisons).
  The joint-channel timeout is recorded there, in `DEPLOY.md` ("Known scale
  walls") and `.specify/specs/results-2026-08-19-CSHZAD026.md`.
* Study: [dandi/compression-comparisons-t261-study](https://github.com/dandi/compression-comparisons-t261-study),
  a DataLad dataset with a `datalad run` record for every condition. Reports
  are in `derivatives/reports-2026-08-29/`; per-condition metrics are in
  `derivatives/compbench-2026-08-25-t261-vs-paper-codecs/`.

**Data.**

* Real recordings: four Neuropixels 1.0 recordings from the Buccino et al.
  benchmark set (two IBL/SpikeGLX, two AIND/Open Ephys). 384 channels,
  30 kHz, int16, 300 s each, compressed in 10 s chunks.
* The two Open Ephys recordings were evaluated both as stored (multiples
  of 12) and LSB-corrected, giving six inputs.
* Sorting and waveform fidelity used one simulated recording with ground
  truth (MEArec, Neuropixels 1.0 geometry, 100 units, 600 s).

**T.261.** ITU-T reference software `vceg-sw/bwc`, `BWC-6.0-2-g34c2a2a`,
stock EEG presets:

* Lossless: `combinedPresetEEG_IndepChannel_lossless`.
* Lossy: `combinedPresetEEG_IndepChannel` with `StepSizeForQP` ∈
  {1.5, 2, 3, 5, 8}.
* Joint-channel: `combinedPresetEEG_lossless`, which timed out.

**Lossless compression (median CR over the six inputs).**

| codec      | median CR | range       |
| ---------- | --------: | ----------- |
| T.261      |     3.563 | 2.01 – 3.80 |
| WavPack    |     3.557 | 2.00 – 3.67 |
| FLAC       |     2.534 | 1.91 – 3.44 |
| blosc-zstd |     2.516 | 2.04 – 3.17 |
| lzma       |     2.476 | 2.08 – 2.83 |
| zstd       |     2.346 | 1.92 – 2.80 |

## Caveats

* **Sorting and waveform results rest on one simulated recording.**
  Differences smaller than ~17 false-positive units at matched CR cannot be
  resolved from it. Sorting on real recordings is not yet done.
* **Throughput figures are wall-clock and untuned.** T.261 ran as a
  subprocess round-tripping through files, single-threaded, on a host
  shared with other benchmark jobs. The general-purpose codecs ran at high
  levels (`zstd` 22, `lzma` 9), which is why they are slow too. An
  in-process build would be faster, but we do not expect it to close a
  12–70x gap to WavPack.
* **Joint-channel coding was tried once:** a single 10 s excerpt of one
  recording, at 384 channels, with a 30-minute timeout. We did not
  characterise how its cost scales with channel count, so it may be
  practical for EEG-sized montages.
* **We used the reference encoder's stock EEG presets.** Presets tuned for
  30 kHz microelectrode data might do better, and we would welcome
  guidance.
