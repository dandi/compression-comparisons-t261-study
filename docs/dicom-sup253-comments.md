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

We are the team behind the DANDI Archive, the NIH BRAIN Initiative archive
for neurophysiology, which holds a large and growing volume of extracellular
microelectrode recordings. These are sampled at ~30 kHz on hundreds of
channels per probe, which puts them at the far end of the envelope the
Supplement describes: a single Neuropixels probe produces 23 MB/s, or
~83 GB per hour, uncompressed. Microelectrode recordings are also clinical
data: intraoperative microelectrode recording (MER) during deep brain
stimulation surgery, and intracortical brain-computer interface trials.

We welcome a standardized, lossless-capable waveform codec in DICOM, and we
benchmarked T.261 independently on this class of data. The comparison set
and protocol are those of Buccino et al. 2023 (J Neural Eng,
[10.1088/1741-2552/acf5a4](https://doi.org/10.1088/1741-2552/acf5a4)), whose
lossless results we first reproduced to within 0.02 % median (1.16 % max)
per recording. The main findings that bear on the Supplement:

1. **T.261 compresses these recordings well, but only in its
   independent-channel configuration.** Lossless CR 3.56 (median), tied with
   WavPack (3.60) and ~44 % ahead of the best general-purpose codec (`lzma`,
   2.48). The joint-channel configuration, the only one Closed Issue #10
   admits, never finished: encoding 10 s of 384-channel data took more than
   30 minutes.
2. **The reference software is 5–50x slower than real time.** Decoding took
   ~5 s of CPU per second of recording, for lossless and lossy alike.
3. **Compression ratio does not measure lossy fidelity.** At one fixed
   quantizer step, CR varied 5x across our six recordings while the absolute
   error held constant. Recording only Lossy Waveform Compression Ratio
   (Open Issue #21) loses the one parameter that predicts fidelity.
4. **At moderate settings, lossy T.261 preserved spike sorting and spike
   waveforms.** Up to QP 5.0 (CR 8.6), unit recovery stayed within
   two units of lossless and waveform features stayed within a 10 % tolerance.
   Spurious units rose steadily with QP, and QP 8.0 failed the waveform
   test.

Details, evidence and caveats follow the comments.

## Comments

### Comment 1 (technical, major): the lossless Transfer Syntax should not exclude independent-channel coding

**Where:** Closed Issue #10 (p. 8); A.X.1, lines 540–550.

**Comment.** Closed Issue #10 settles on one lossless Transfer Syntax using
"joint channels". It dismisses "individual channels" on the grounds that it
"is expected to result in little compression ratio". On 384-channel,
30 kHz recordings we found the opposite, in practice:

* Independent-channel lossless T.261
  (`combinedPresetEEG_IndepChannel_lossless`) reached a median CR of 3.56 on
  six real recordings. That ties WavPack (3.60) and beats every
  general-purpose codec (`lzma` 2.48, `zstd` 2.35, `blosc-zstd` 2.52).
* Joint-channel lossless T.261 (`combinedPresetEEG_lossless`) did not finish
  encoding a 10 s, 384-channel excerpt within 30 minutes, i.e. more than
  180x slower than real time. We could not obtain a single joint-channel
  result on this data. A full 1–2 h recording would take days per probe.

If the Transfer Syntax, or conformance to it, requires joint-channel
coding, T.261 is not usable for high-channel-count microelectrode data. We
understand that the channel-group configuration is signalled in the
bitstream (CGP_SPT), so any conformant decoder handles either grouping.
Excluding independent-channel coding therefore buys no decoder simplicity.
It only removes the encoder configuration that works for this modality.

**Proposed solution.** Reopen Closed Issue #10. In A.X.1, state explicitly
that the lossless and lossy Transfer Syntaxes do not constrain the
channel-group configuration: joint, independent, or any partition of the
Multiplex Group's channels into channel groups is permitted, as signalled
by the CGP_SPT stream packets. If WG-06 prefers a single recommended
default, put it in an informative note, not in the Transfer Syntax
definition.

### Comment 2 (technical): computational cost at high channel count and sampling rate

**Where:** Closed Issue #1 (p. 7); Closed Issue #2 (p. 7); Section 10.1,
lines 452–475 (the obligation to convert to the Default Transfer Syntax).

**Comment.** Closed Issue #1 evaluates the codec on compression ratio only.
For microelectrode data, throughput matters as much. On the reference
software (`vceg-sw/bwc`, the implementation Closed Issue #2 points
implementers to), measured single-threaded on 384-channel, 30 kHz data:

| codec (mode)          | encode, x real time | decode, x real time |
| --------------------- | ------------------: | ------------------: |
| T.261 lossless        |               0.080 |                0.21 |
| T.261 lossy           |               0.019 |                0.20 |
| WavPack lossless      |                2.97 |                3.34 |
| WavPack hybrid lossy  |                1.38 |                2.49 |
| FLAC lossless         |                3.99 |                5.93 |
| blosc-zstd (level 9)  |                0.32 |               25.64 |

Values below 1 are slower than real time. At 0.21x decode, simply reading
back one hour of one probe costs ~5 CPU-hours. Every sending AE that must
fall back to the Default Transfer Syntax (Section 10.1), and every viewer,
pays this cost.

These figures carry caveats (see Caveats): the encoder was driven through
files, single-threaded, on a shared host. The ratios between codecs are
more trustworthy than the absolute values. Still, T.261 is 15–70x slower than WavPack, which compresses
this data equally well, and its decoder runs 5x slower than real time.

**Proposed solution.** We ask WG-32 to publish throughput figures for the
reference software at high channel count and sampling rate. We also ask
that the Supplement state that T.261 decode cost scales with channel count
× sampling rate, so implementers of archives and viewers can plan for it.
If parallel decoding by channel group is what makes this practical, that
argues again for Comment 1.

### Comment 3 (technical): 1024-channel limit in Table 8.3.1-1

**Where:** Section 8.3.1, Table 8.3.1-1, lines 436–439; Open Issue #16
(p. 8–9).

**Comment.** Table 8.3.1-1 caps Number of Channels at 1024 for every sample
interpretation. It is not stated whether this is a limit of T.261 or a DICOM
choice. The Scope (lines 107–108) says T.261 supports "large numbers of
channels". Several recording systems already exceed 1024 simultaneously
sampled channels at a common sampling rate: multi-probe Neuropixels
recordings (384 channels per probe), high-density CMOS microelectrode
arrays, and intracortical BCI implants with 1000+ electrodes. Open Issue #16
states that WG-32 knows of no use case for more than one Multiplex Group.
If the cap stays, microelectrode arrays are such a use case, because data
would have to be split into several groups.

**Proposed solution.** State the origin of the 1024 limit. If it is not a
T.261 constraint, raise it (to 65535, matching the US VR of Number of
Waveform Channels (003A,0005)) or remove it. If it is a T.261 constraint,
add a note that larger arrays must be split across Multiplex Groups. Add
high-channel-count microelectrode recording to the use cases recorded under
Open Issue #16.

### Comment 4 (technical, major): convey the quantizer step, not only the compression ratio (answer to Open Issue #21)

**Where:** Open Issue #21 (p. 6); C.10.9.1.X2.2, lines 219–229; Open Issue #23
(p. 6).

**Comment.** Lossy Waveform Compression Ratio is the only fidelity
indicator the Supplement records. Our data show that for T.261 it is not
one. The same quantizer step (`StepSizeForQP`) gives almost the same
absolute error on every recording, while the resulting CR depends on the
recording and varies up to 5x. WavPack's hybrid mode shows the inverse
pattern: fixed bitrate, varying error. Six recordings, 300 s each:

| setting               |      CR range | RMSE range (stored units) |
| --------------------- | ------------: | ------------------------: |
| T.261 QP 1.5          |   2.06 – 4.40 |               0.45 – 0.46 |
| T.261 QP 3.0          |   2.40 – 6.21 |               0.83 – 0.87 |
| T.261 QP 8.0          |  3.07 – 16.80 |               2.11 – 2.44 |
| WavPack hybrid 2.25 b |   7.10 – 7.16 |              1.81 – 25.84 |

A CR of 5 can therefore mean QP 1.5 on one recording and QP 8 on another,
two settings with very different consequences downstream (see Comment 5).
In our spike-sorting evaluation, spurious units rose monotonically with QP
(129 → 133 → 138 → 145 → 184 for QP 1.5 → 8.0), while WavPack's scattered
with no trend across its bitrate settings (143, 128, 135, 131 for 4.0 →
2.25 bps).

**Proposed solution.** Answer Open Issue #21 affirmatively. Add a
multi-valued attribute for the T.261 quantization step size (QP), parallel
to Lossy Waveform Compression Method (ggg1,eee2). Where the encoder enables
them, also add the maximum absolute error (MAE) and SNR quality indicators.
Require that Lossy Waveform Compression Ratio be the measured value, not a
nominal estimate (lines 226–228), because a nominal CR is meaningless for
an encoder whose CR depends on the recording. For Open Issue #23, make the
QP attribute a Repository Query key as well as the CR.

### Comment 5 (informative): lossy suitability evidence for extracellular recordings

**Where:** Section 8.3.1, Note, lines 424–428.

**Comment.** We agree that clinical acceptability is out of scope for the
Standard. We offer evidence, in case it helps WG-32 or implementers. On a
simulated Neuropixels 1.0 recording (MEArec, 600 s, 100 ground-truth
units), sorted with Kilosort 4:

| arm               |     CR | well detected | false positive | waveform p90 err |
| ----------------- | -----: | ------------: | -------------: | ---------------: |
| lossless baseline |  3.721 |            96 |            126 |                0 |
| T.261 QP 1.5      |  4.270 |            94 |            129 |            0.038 |
| T.261 QP 3.0      |  5.989 |            98 |            138 |            0.034 |
| T.261 QP 5.0      |  8.575 |            96 |            145 |            0.085 |
| T.261 QP 8.0      | 14.514 |            99 |            184 |            0.145 |
| WavPack 2.25 bps  |  7.101 |            97 |            131 |            0.057 |

"Waveform p90 err" is the 90th percentile, over units, of the relative error
in spike-waveform features. It uses the 10 % tolerance of Buccino et al.
(Fig. 14), computed from ground-truth spike times so no sorter is involved;
it comes from a 100 s excerpt of the same recording.
Through QP 5.0, T.261 keeps unit recovery within two units of lossless and passes
the waveform criterion. It compresses ~21 % harder than WavPack's best
passing setting, but at the cost of more spurious units (+19 vs +5). QP 8.0
fails the waveform criterion. The practical lesson for this modality is
that the quantizer should be chosen by its effect on spike detection, not
by CR. That lesson carries over to Comment 4.

**Proposed solution.** No normative change. Optionally, add to the Note
that the suitability of a given lossy setting depends on the downstream
analysis and should be established per modality.

### Comment 6 (technical): integer scale factors defeat lossless compression; guidance for producers

**Where:** Section 8.3.1, lines 429–432.

**Comment.** Some acquisition software rescales samples to a fixed physical
unit before storing them. Open Ephys, for instance, stores Neuropixels 1.0
data as exact multiples of 12. The low log2(12) ≈ 3.6 bits then carry no
information, and neither T.261 nor WavPack notices. On the same two
recordings, T.261 lossless CR was 2.01 / 2.08 as stored and 3.53 / 3.65
once each channel was re-expressed with an LSB of 1: a 75 % difference.
Waveform Bits Stored can only express power-of-two headroom, so this
redundancy cannot be signalled.

**Proposed solution.** Add an informative note recommending that producers
store sample values in native ADC counts (LSB = 1), and carry the physical
scaling in Channel Sensitivity (003A,0210) and Channel Sensitivity
Correction Factor (003A,0212), which already exist for this purpose. We
would also suggest to ITU-T that a future T.261 revision detect and signal
a common integer scale factor per channel, similar to FLAC's "wasted bits"
but not limited to powers of two.

### Comment 7 (technical): stream sizes exceed 32-bit offsets within minutes

**Where:** A.X, lines 528–535 (Basic Offset Table); Closed Issues #15 and
#18 (p. 8); Open Issue #22 (p. 6).

**Comment.** One 384-channel, 30 kHz, 16-bit probe passes 2^32 bytes after
~3 minutes uncompressed, and the compressed stream after ~11 minutes at CR 3.5. Recordings of 1–2
hours are routine. A.X keeps a Basic Offset Table of 32-bit offsets.
Closed Issue #15 states that T.261's internal indexing makes an offset
table unnecessary. The normative text, however, still permits a non-empty
32-bit table, which would silently overflow for this data. Separately, our
community routinely reads time windows of long recordings.

**Proposed solution.** Either require the Basic Offset Table to be empty for
T.261 Transfer Syntaxes, deferring random access to T.261's own index, or
define a 64-bit offset table for waveforms analogous to Extended Offset
Table (7FE0,0001) for Pixel Data. Answer Open Issue #22
affirmatively: a DICOMweb mechanism to retrieve a time range of a
waveform, analogous to frame retrieval, would be widely used for this data.

### Comment 8 (general): rationale for excluding other codecs should be scoped to the modalities evaluated

**Where:** Closed Issue #1 (p. 7); Closed Issue #17 (p. 9).

**Comment.** Closed Issue #1 says standardized audio codecs "did not produce
a sufficient result". On microelectrode data, WavPack, an open audio codec,
matched T.261 lossless (CR 3.60 vs 3.56) and was one to two orders of
magnitude faster (15–70x; Comment 2). It is also the codec Buccino et al. recommend
for this modality. FLAC reached 2.53 here, so we do not argue for FLAC on
merit. However, the stated reason for not evaluating it, "only supports up
to 8 channels", is a per-stream limit. Per-channel FLAC streams are how
FLAC is commonly applied to multichannel electrophysiology.

**Proposed solution.** Scope the answer to Closed Issue #1 to the modalities
actually evaluated (ECG/EEG?), and publish or cite that evaluation. Correct
the FLAC rationale in Closed Issue #17. We do not propose adding either
codec to this Supplement. The record should simply not imply evidence that
does not extend to all waveform modalities.

### Comment 9 (general): patent status

**Where:** Open Issue #3 (p. 6).

**Comment.** The reference software's Clear BSD license explicitly grants no
patent rights, and Open Issue #3 records that no patent declarations have
been filed. Open-science archives such as DANDI, and the open-source tools
that read their data, can adopt a format only if implementations can be
freely redistributed.

**Proposed solution.** Before final text, obtain royalty-free declarations
(or confirmation that none are required) from the T.261 contributors, and
record the outcome in the Supplement.

### Comment 10 (editorial)

**Where:** A.X, lines 501 and 519.

**Comment.** "Waveform Data (5400,0010)" should read (5400,1010), as
elsewhere in the Supplement. Also line 415: "support s one ore more" →
"supports one or more".

**Proposed solution.** Correct the tags and typo.

## Evidence

All numbers above come from an open, reproducible benchmark:

* Tool: [dandi/compression-comparisons](https://github.com/dandi/compression-comparisons)
* Study (DataLad dataset with every per-condition `datalad run` record):
  [dandi/compression-comparisons-t261-study](https://github.com/dandi/compression-comparisons-t261-study),
  reports in `derivatives/reports-2026-08-29/`

**Data.** Real recordings: four Neuropixels 1.0 recordings from the Buccino
et al. benchmark (two IBL/SpikeGLX, two AIND/Open Ephys), 384 channels,
30 kHz, int16, 300 s each. The two Open Ephys recordings were evaluated
both as stored and LSB-corrected, giving six inputs; data were compressed
in 10 s chunks. Sorting and waveform fidelity used one simulated
recording (MEArec, Neuropixels 1.0 geometry, 100 units, 600 s) with ground
truth.

**T.261.** ITU-T reference software `vceg-sw/bwc`, commit `34c2a2a`, stock
EEG presets. Lossless: `combinedPresetEEG_IndepChannel_lossless`. Lossy:
`combinedPresetEEG_IndepChannel` with `StepSizeForQP` ∈ {1.5, 2, 3, 5, 8}.
Joint-channel: `combinedPresetEEG_lossless` (timed out).

**Lossless compression (median CR over the six inputs).**

| codec      | median CR | range       |
| ---------- | --------: | ----------- |
| WavPack    |     3.595 | 2.00 – 3.67 |
| T.261      |     3.563 | 2.01 – 3.80 |
| FLAC       |     2.534 | 1.91 – 3.44 |
| blosc-zstd |     2.516 | 2.04 – 3.17 |
| lzma       |     2.476 | 2.08 – 2.83 |
| zstd       |     2.346 | 1.92 – 2.80 |

## Caveats

* **Sorting and waveform results rest on one simulated recording.**
  Differences smaller than ~17 false-positive units at matched CR are not
  resolvable from it. Sorting on real recordings is not yet done.
* **Throughput figures are not tuned.** T.261 ran as a subprocess
  round-tripping through files, single-threaded, on a host shared with
  other benchmark jobs. The general-purpose codecs ran at high levels
  (`zstd` 22, `lzma` 9), which is why they are slow too. An in-process
  build would be faster, but we do not expect it to close a 15–70x gap to
  WavPack.
* **Joint-channel coding** was tried only at 384 channels, with a 30 min
  timeout. We did not characterise how its cost scales with channel count,
  so it may be practical for EEG-sized montages.
* We used the reference encoder's stock presets. Presets tuned for 30 kHz
  microelectrode data might do better, and we would welcome guidance.
