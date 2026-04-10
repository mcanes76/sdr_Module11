# Problem 2.1: ROC for Energy Detector Simulation Plan

**Pending review - not yet executed.**

Documentation generated for review only. No scripts or simulations have been executed.

## Goal of the Simulation
Prepare a simple implementation plan for the energy detector ROC problem at `SNR = -3 dB` with `K = 32` complex samples, using one theoretical path and one Monte Carlo path over the same threshold vector.

## Theoretical Formula Notes
Use the decision metric

$$
T = \sum_{n=1}^{K} |r[n]|^2
$$

Write the decision rule explicitly:

Decide $H_1$ if $T > \eta$; otherwise decide $H_0$.

Use the theoretical false-alarm expression

$$
P_{FA} = \mathrm{gammainc}\!\left(\frac{\eta}{2\sigma_n^2},\, K,\, \text{upper}\right)
$$

Use the theoretical detection expression

$$
P_D = \mathrm{marcumq}\!\left(\frac{\sqrt{E_s}}{\sigma_n},\, \frac{\sqrt{\eta}}{\sigma_n},\, K\right)
$$

For a constant-amplitude signal,

$$
E_s = |A|^2 K
$$

so the MATLAB expression can also be written as

$$
P_D = \mathrm{marcumq}\!\left(\frac{|A|\sqrt{K}}{\sigma_n},\, \frac{\sqrt{\eta}}{\sigma_n},\, K\right)
$$

## Threshold Plan
Use the assignment threshold definition directly:

$$
\texttt{threshold\_base} = 0.1:0.1:20
$$

$$
\texttt{threshold\_range} = \texttt{threshold\_base} \cdot K
$$

This scaling by measurement length should be preserved in both the theoretical and simulated ROC paths.

## SNR Mapping for the Simulation
Convert the assignment SNR to linear form using

$$
\mathrm{SNR}_{\text{linear}} = 10^{\mathrm{SNR}_{dB}/10}
$$

For a simple complex-baseband model with constant amplitude $A$ and noise standard deviation $\sigma_n$, use the working assumption

$$
\mathrm{SNR} = \frac{|A|^2}{2\sigma_n^2}
$$

If $\sigma_n$ is chosen first, then set

$$
A = \sqrt{2\sigma_n^2 \cdot \mathrm{SNR}_{\text{linear}}}
$$

This keeps the simulation notes consistent with the theoretical model.

## Step-by-Step Execution Plan
1. Define shared parameters: `K = 32`, `SNR = -3 dB`, $\sigma_n$, threshold vector, and Monte Carlo trial count.
2. Build `threshold_range` by scaling the base sweep by `K`.
3. Convert SNR from dB to linear scale.
4. Choose $\sigma_n$ and compute the corresponding constant signal amplitude $A`.
5. Compute the theoretical ROC over the full threshold vector.
6. Run noise-only trials to estimate $P_{FA}$.
7. Run signal-plus-noise trials to estimate $P_D$.
8. Overlay the theoretical and simulated ROC curves.

## Proposed File List to Implement Later
- `main_problem_2_1.m`
- `compute_theoretical_roc.m`
- `simulate_energy_detector_roc.m`

## Implementation Style Note
The MATLAB code should follow the live lab style:

- simple
- short
- minimal comments
- no heavy input checking
- no over-engineering

## Verification Strategy
- Check that all probabilities remain within $[0,1]$.
- Check that the threshold range covers both low and high false-alarm regions.
- Check that simulated ROC points follow the expected monotonic trend.
- Check that the simulated curve is reasonably close to the theoretical curve.
- Check that the same $\sigma_n$ is used in both the noise-only and signal-plus-noise trials.

## Expected Plots / Tables
- One ROC overlay plot comparing theoretical and simulated curves
- Optional short parameter table listing `K`, SNR, threshold range, and trial count

## Review Checklist Before Coding
- Confirm the threshold vector definition and scaling by `K`.
- Confirm the SNR-to-amplitude mapping.
- Confirm the intended Monte Carlo trial count.
- Confirm that the live-lab-style simplified implementation is preferred.

## Open Questions / Review Items
- Confirm whether the signal model should remain a constant-amplitude complex signal.
- Confirm whether any additional diagnostic plot is needed beyond the ROC overlay.
- Once this documentation is approved, MATLAB code generation can begin.
