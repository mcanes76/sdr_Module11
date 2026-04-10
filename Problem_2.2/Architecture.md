# Problem 2.2: Packet Error Rate with CRC-16 and Hamming(7,4)

**Do not execute until reviewed.**

Documentation generated for review only. No scripts or simulations have been executed.

## Purpose / Assignment Intent
Design a packet-level simulation that compares uncoded and Hamming-coded packet error rate (PER) performance across `0:9 dB`, while preserving CRC-based packet validation and reporting an accuracy metric against known truth data.

## Requirements Summary
### Assignment Requirement
- Start from a `192`-bit payload.
- Append `CRC-16` to form `208` bits.
- Apply Hamming(7,4) coding to the entire `208`-bit packet to obtain `364` coded bits.
- Simulate modulation, noise addition, demodulation, hard decoding, Hamming decoding, and CRC validation.
- Evaluate `SNR = 0:9 dB`.
- Plot PER with and without Hamming(7,4).
- Plot accuracy with respect to truth data.

### Implementation Proposal
- Use BPSK unless the existing repository or rubric indicates a different modulation.
- Keep the CRC stage common to both uncoded and coded paths so packet validity has the same meaning in both cases.
- Define coded versus uncoded fairness using an explicit energy-per-information-bit convention before implementation.

## Inputs and Outputs
### Inputs
- Random or predetermined `192`-bit payloads.
- CRC-16 generator/checking convention.
- SNR vector `0:9 dB`.
- Trial count per SNR point.
- Modulation and hard-demodulation mapping.

### Outputs
- Uncoded PER versus SNR.
- Coded PER versus SNR.
- Accuracy metric versus SNR.
- Optional result structure containing trial counts, CRC failures, decoder outcomes, and bitwise accuracy.

## Assumptions and Interpretation Notes
- The existing repository uses `Problem_2.2`, so documentation follows that folder style.
- The packet lengths should align exactly:
  - payload: `192` bits
  - payload + CRC: `208` bits
  - Hamming(7,4) coded packet: `364` bits
- Since CRC is part of the assignment-defined packet structure, the cleanest baseline proposal is to transmit the `208`-bit CRC-appended packet uncoded in the baseline branch and to transmit the `364`-bit Hamming-coded packet in the coded branch.
- The statement about adjusting noise for fairness should be made explicit before coding. A recommended interpretation is fairness in $E_b/N_0$ with respect to the original `192` information bits, not merely transmitted symbol energy.
- "Accuracy with respect to truth data" is ambiguous from the summary alone. A practical proposal is to report bit accuracy relative to the original payload and optionally packet-level correctness as a secondary metric.

## Proposed Software Architecture
The simulation should use two parallel packet-processing pipelines driven by a shared top-level controller:

1. An uncoded baseline path for payload + CRC transmission.
2. A coded path that adds Hamming(7,4) redundancy before modulation.

Both paths should use the same payload source, CRC logic, SNR vector, and channel model. The top-level driver should accumulate packet outcomes across trials, compute PER and accuracy metrics, and generate comparison plots.

## Functional Decomposition into MATLAB Scripts/Functions
- `main_problem_2_2.m`
  Defines parameters, loops over SNR, accumulates statistics, and produces final plots.
- `append_crc16.m`
  Appends CRC-16 bits to a 192-bit payload to form a 208-bit packet.
- `check_crc16.m`
  Verifies CRC correctness after demodulation/decoding.
- `hamming74_encode_packet.m`
  Encodes the full 208-bit packet in 4-bit blocks to produce 364 coded bits.
- `hamming74_decode_packet_hard.m`
  Performs hard-decision Hamming(7,4) decoding and returns the recovered 208-bit packet.
- `bpsk_modulate_bits.m`
  Maps bits to BPSK symbols.
- `bpsk_demod_hard.m`
  Converts noisy received symbols to hard bits.
- `run_per_trial_uncoded.m`
  Executes one uncoded packet trial and returns CRC/pass-fail outcomes.
- `run_per_trial_coded.m`
  Executes one coded packet trial and returns decoder and CRC outcomes.
- `compute_accuracy_metrics.m`
  Computes payload bit accuracy and any secondary correctness metrics.
- `helper_plot_per_accuracy.m`
  Generates PER and accuracy plots.

## Data Flow
1. Generate or load a `192`-bit truth payload.
2. Append CRC-16 to create the `208`-bit transmit packet.
3. Branch into uncoded and coded paths.
4. Uncoded path:
   - BPSK modulate `208` bits.
   - Apply AWGN with the chosen fairness convention.
   - Hard demodulate.
   - CRC-check the recovered `208` bits.
   - Compare recovered payload bits to truth payload.
5. Coded path:
   - Hamming encode all `208` bits into `364` bits.
   - BPSK modulate coded bits.
   - Apply AWGN with coded-case fairness adjustment.
   - Hard demodulate.
   - Hamming decode back to `208` bits.
   - CRC-check the recovered `208` bits.
   - Compare recovered payload bits to truth payload.
6. Aggregate PER and accuracy statistics across SNR and trials.

## Key Formulas and Algorithm Notes
### Assignment Requirement
- Packet lengths:
  $$
  192 \xrightarrow{\text{CRC-16}} 208 \xrightarrow{\text{Hamming(7,4)}} 364
  $$
- Packet error proposal:
  $$
  \mathrm{PER} = \frac{\text{number of packets failing CRC after receiver processing}}{\text{total packets transmitted}}
  $$

### Fairness Note
- For BPSK with equal symbol energy, coded transmission sends more symbols per payload. To compare fairly in $E_b/N_0$, the noise variance or symbol scaling must reflect the effective code rate.
- Two defensible rate definitions should be documented before coding:
  $$
  R_{\text{payload, uncoded}} = \frac{192}{208}, \qquad
  R_{\text{payload, coded}} = \frac{192}{364}
  $$
  or, if CRC overhead is treated as common overhead and only Hamming overhead is emphasized,
  $$
  R_{\text{CRC-packet, coded}} = \frac{208}{364} = \frac{4}{7}
  $$
- The implementation should explicitly state which fairness definition is used and keep it consistent in all figures and captions.

## Plot / Report Deliverables Expected
- PER versus SNR for uncoded and coded cases on the same plot.
- Accuracy versus SNR for the chosen truth-based metric.
- Optional table showing packet counts, CRC failure counts, and bit-accuracy summaries per SNR.
- Brief explanation of the fairness convention used for uncoded versus coded comparison.

## Risks / Validation Concerns
- An incorrect CRC convention will corrupt PER measurements even if the channel simulation is otherwise correct.
- Hamming block packing must preserve bit ordering exactly across encode and decode.
- Unclear $E_b/N_0$ fairness handling can invalidate the coded-versus-uncoded comparison.
- "Accuracy with respect to truth data" must be defined precisely before implementation to avoid changing metrics midstream.

## Open Questions / Review Items
- Confirm whether BPSK is the intended modulation or merely a recommended implementation choice.
- Confirm whether PER for the uncoded branch should still be CRC-based on the `208`-bit packet.
- Confirm whether the accuracy plot should report payload bit accuracy, packet correctness, or both.
- Confirm whether fairness should be defined relative to the original `192` payload bits or relative to the CRC-appended `208`-bit packet.
