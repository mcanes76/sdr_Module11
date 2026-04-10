# Problem 2.2: Packet Error Rate Simulation Plan

**Pending review - not yet executed.**

Documentation generated for review only. No scripts or simulations have been executed.

## Goal of the Simulation
Prepare a packet-level Monte Carlo plan that compares uncoded and Hamming(7,4)-coded packet performance from `0` to `9 dB`, using CRC-16 for packet validity and a truth-referenced accuracy metric.

## Step-by-Step Execution Plan
1. Define a parameter block for packet lengths, CRC settings, SNR vector `0:9 dB`, trial count, modulation, and fairness convention.
2. Generate a `192`-bit truth payload for each trial, or define a repeatable payload-generation method.
3. Append CRC-16 to create the `208`-bit packet.
4. Execute the uncoded branch:
   - BPSK modulate the `208` bits.
   - Add AWGN according to the selected fairness convention.
   - Hard demodulate to `208` bits.
   - CRC-check and compare payload bits to truth.
5. Execute the coded branch:
   - Hamming-encode the `208` bits into `364` bits.
   - BPSK modulate the coded packet.
   - Add AWGN with coded-case fairness adjustment.
   - Hard demodulate to coded bits.
   - Hamming-decode back to `208` bits.
   - CRC-check and compare payload bits to truth.
6. Repeat across all SNR points and across enough trials for stable PER estimates.
7. Compute PER and accuracy metrics, then generate final plots and any supporting tables.

## Proposed File List to Implement Later
- `main_problem_2_2.m`
- `append_crc16.m`
- `check_crc16.m`
- `hamming74_encode_packet.m`
- `hamming74_decode_packet_hard.m`
- `bpsk_modulate_bits.m`
- `bpsk_demod_hard.m`
- `run_per_trial_uncoded.m`
- `run_per_trial_coded.m`
- `compute_accuracy_metrics.m`
- `helper_plot_per_accuracy.m`

## Parameter Table
| Parameter | Proposed Value / Role | Notes |
|---|---|---|
| Payload length | `192` bits | Assignment requirement |
| CRC length | `16` bits | Assignment requirement |
| Packet before FEC | `208` bits | Must be checked exactly |
| Packet after Hamming(7,4) | `364` bits | Must be checked exactly |
| SNR vector | `0:9 dB` | Assignment requirement |
| Modulation | BPSK | Recommended unless repo style dictates otherwise |
| Demodulation | Hard decision | Assignment requirement |
| Trials per SNR | Configurable | Needs review before coding |
| Fairness convention | `E_b/N_0` based | Must be documented explicitly |

## Verification Strategy
- Verify the length transitions `192 -> 208 -> 364` exactly.
- Verify that uncoded and coded CRC checks are applied to recovered `208`-bit packets.
- Verify that PER is computed strictly from CRC failure after all receiver processing.
- Verify that the accuracy metric is computed against the original truth payload and not against intermediate packets unless intentionally documented.
- Verify that the coded and uncoded branches use a clearly documented fairness normalization.
- Verify that increasing SNR reduces PER in both branches under adequate trial counts.

## Expected Plots / Tables
- PER versus SNR plot with uncoded and Hamming-coded curves.
- Accuracy versus SNR plot.
- Optional table with per-SNR packet counts, CRC failure counts, and bit accuracy.
- Optional note showing the effective rate used for fairness normalization.

## Corner Cases and Sanity Checks
- Zero-noise or very high-SNR trials should approach zero PER.
- Very low-SNR trials should show clear packet degradation.
- If coded PER is worse than uncoded PER at all SNR values, inspect fairness normalization, Hamming packing, and decoder logic first.
- CRC pass on a corrupted payload is theoretically possible but rare; the simulation should still define PER exactly as CRC outcome unless instructed otherwise.
- If `208` is not reshaped cleanly into 4-bit Hamming blocks during implementation, stop and verify bit ordering rather than silently padding.

## Review Checklist Before Coding
- Confirm BPSK as the intended modulation.
- Confirm the CRC polynomial and bit-order convention expected by the course.
- Confirm whether the fairness definition should be based on `192` payload bits or `208` CRC-appended bits.
- Confirm the exact meaning of “accuracy with respect to truth data.”
- Confirm the initial number of Monte Carlo trials per SNR point.
- Confirm whether optional tables are needed in addition to plots.

## Open Questions / Review Items
- Should the truth payload be randomly regenerated every trial or fixed with a reproducible seed?
- Should the coded branch expose decoder syndrome statistics for debugging, or keep the public interface minimal?
- Should the uncoded baseline include soft information later, or remain strictly hard-decision for one-to-one comparison with the assignment wording?
