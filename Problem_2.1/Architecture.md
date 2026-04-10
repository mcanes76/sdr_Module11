# Problem 2.1: ROC for Energy Detector

**Do not execute until reviewed.**

Documentation generated for review only. No scripts or simulations have been executed.

## Purpose / Assignment Intent
Develop a Receiver Operating Characteristic (ROC) study for an energy detector operating at `SNR = -3 dB` with measurement length `L = 32` samples. The assignment requires both a theoretical ROC and a simulated ROC, plotted together for comparison.

## Requirements Summary
### Assignment Requirement
- Use an energy-based decision metric over 32 samples.
- Evaluate both false-alarm probability and detection probability across a shared threshold vector.
- Use `SNR = -3 dB`.
- Plot theoretical and simulated ROC curves on the same axes.
- Use noise-only trials for `P_{fa}` and signal-plus-noise trials for `P_d` with the same noise variance in both cases.

### Implementation Proposal
- Model the received measurement as complex baseband data, consistent with the live-lab script style.
- Build one threshold vector scaled by measurement length so the detector threshold remains comparable as `L` changes.
- Compute theory and Monte Carlo estimates from the same parameter set to avoid hidden mismatches.

## Inputs and Outputs
### Inputs
- Measurement length `L = 32`.
- SNR value `-3 dB`.
- Noise standard deviation or noise power definition.
- Threshold vector $\lambda$.
- Number of Monte Carlo trials.

### Outputs
- Theoretical $P_{fa}$ and $P_d$ arrays.
- Simulated $P_{fa}$ and $P_d$ arrays.
- ROC overlay plot: simulated versus theoretical.
- Optional summary structure containing parameters and curve data.

## Assumptions and Interpretation Notes
- The existing repository uses `Problem_2.1` naming, so this documentation follows that folder convention rather than creating a new lowercase directory.
- The live lab uses complex AWGN and energy metric $\sum |x[n]|^2$; this is the proposed interpretation here.
- For circular complex AWGN with per-axis standard deviation $\sigma$, the total noise power per sample is $E\{|n|^2\} = 2\sigma^2$.
- A consistent SNR mapping is required before implementation. One practical proposal is
  $$
  |A|^2 = 10^{\mathrm{SNR}_{dB}/10} \cdot 2\sigma^2
  $$
  where `A` is the deterministic signal amplitude magnitude used in signal-plus-noise trials.
- The threshold vector should be scaled by measurement length, for example $\lambda = L \cdot \alpha$, where $\alpha$ is a configurable normalized threshold sweep.

## Proposed Software Architecture
The design should separate theory, simulation, and plotting into distinct functions. A top-level driver should define parameters, build the threshold vector, invoke the theoretical and simulated ROC paths, and produce a single comparison figure.

Theoretical and simulation paths should share the same `L`, SNR definition, noise variance, and threshold vector. This avoids a common failure mode in which the Monte Carlo branch and analytical branch use different normalizations.

## Functional Decomposition into MATLAB Scripts/Functions
- `main_problem_2_1.m`
  Central driver for parameter definition, function calls, and plot generation.
- `compute_theoretical_roc.m`
  Computes theoretical $P_{fa}$ and $P_d$ across the threshold vector.
- `simulate_energy_detector_roc.m`
  Runs Monte Carlo trials for noise-only and signal-plus-noise cases.
- `generate_complex_awgn.m`
  Returns complex noise with a controlled variance definition.
- `helper_plot_roc.m`
  Produces the overlay plot and any optional annotation.

## Data Flow
1. Driver defines `L`, SNR, noise variance, threshold vector, and trial count.
2. Driver passes common parameters to `compute_theoretical_roc`.
3. Driver passes the same common parameters to `simulate_energy_detector_roc`.
4. Theoretical branch returns vectors `$$(P_{fa}^{th}, P_d^{th})$$`.
5. Simulation branch returns vectors `$$(P_{fa}^{sim}, P_d^{sim})$$`.
6. Plot helper overlays simulated and theoretical ROC curves.
7. Driver optionally stores results in a struct for later review.

## Key Formulas and Algorithm Notes
### Assignment Requirement
- Decision metric:
  $$
  T = \sum_{n=1}^{L} |x[n]|^2
  $$

- Decision rule:
  $$
  T > \lambda \;\; \text{decide } H_1,\qquad
  T < \lambda \;\; \text{decide } H_0
  $$

### Live-Lab Guidance
- Theoretical false alarm probability:
  $$
  P_{fa} = \mathrm{gammainc}\!\left(\frac{\lambda}{2\sigma^2},\, L,\, \text{upper}\right)
  $$
- Theoretical detection probability:
  $$
  P_d = \mathrm{marcumq}\!\left(\frac{\sqrt{|A|^2 L}}{\sigma},\, \frac{\sqrt{\lambda}}{\sigma},\, L\right)
  $$
  where $\mathrm{marcumq}(\cdot,\cdot,\cdot)$ denotes the generalized Marcum Q-function in MATLAB.

### Monte Carlo Proposal
- Under $H_0$, generate noise-only measurements and compute the fraction with $T > \lambda$.
- Under $H_1$, generate signal-plus-noise measurements with the same noise variance and compute the fraction with $T > \lambda$.
- Use the same threshold sweep for both $P_{fa}$ and $P_d$.

## Plot / Report Deliverables Expected
- ROC overlay plot with theoretical and simulated curves.
- Optional parameter table listing `L`, SNR, noise variance convention, threshold sweep, and trial count.
- Optional note on the maximum absolute or RMS mismatch between theory and simulation.

## Risks / Validation Concerns
- SNR normalization can be implemented incorrectly if signal amplitude and noise power are not defined from the same convention.
- A threshold sweep that is too narrow may fail to show both the low-$P_{fa}$ and high-$P_d$ regions.
- Insufficient Monte Carlo trials may cause visibly noisy ROC estimates, especially in low-probability regions.
- Use of real-noise formulas instead of complex-noise formulas would shift the theoretical curve.

## Open Questions / Review Items
- Confirm whether the signal model should be a deterministic complex constant, a tone, or any other specified waveform under `H_1`.
- Confirm whether the SNR definition should reference total complex noise power $2\sigma^2$ or another course-specific convention.
- Confirm whether the final report should include a histogram or threshold-study diagnostic in addition to the ROC overlay.
