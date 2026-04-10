# Problem 2.1: ROC for Energy Detector Simulation Plan

**Problem 2.1 implementation plan and execution notes.**

## Goal of the Simulation
Generate theoretical and simulated ROC curves for an energy detector at `SNR = -3 dB` with `K = 32` complex samples, then overlay the two curves on the same figure.

## Theoretical Formula Notes
Use the decision metric

$$
T = \sum_{n=1}^{K} |r[n]|^2
$$

Use the explicit decision rule:

Decide $H_1$ if $T > \eta$; otherwise decide $H_0$.

Use

$$
P_{FA} = \mathrm{gammainc}\!\left(\frac{\eta}{2\sigma_n^2},\, K,\, \text{upper}\right)
$$

and

$$
P_D = \mathrm{marcumq}\!\left(\frac{\sqrt{E_s}}{\sigma_n},\, \frac{\sqrt{\eta}}{\sigma_n},\, K\right)
$$

with

$$
E_s = |A|^2 K
$$

so that

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

The same `threshold_range` is used in both the theoretical and simulated ROC calculations.

## SNR Mapping and Noise Generation
Convert SNR to linear scale using

$$
\mathrm{SNR}_{\text{linear}} = 10^{\mathrm{SNR}_{dB}/10}
$$

Use the working assumption

$$
\mathrm{SNR}_{\text{linear}} = \frac{|A|^2}{\sigma_n^2}
$$

so

$$
A = \sigma_n \sqrt{\mathrm{SNR}_{\text{linear}}}
$$

Complex AWGN should be generated as

$$
n = \frac{\sigma_n}{\sqrt{2}}\left(n_I + j n_Q\right)
$$

The $\sqrt{2}$ appears because the real and imaginary branches split the total complex noise power equally. Each branch then has variance $\sigma_n^2/2$, so the total complex noise power is $\sigma_n^2$.

## Step-by-Step Execution Plan
1. Define `K = 32`, `SNR_dB = -3`, `num_trials = 100000`, `sigma_n = 1`, and `threshold_range`.
2. Convert SNR from dB to linear scale.
3. Compute the constant signal amplitude from the revised sigma convention.
4. Compute the theoretical ROC over the full threshold range.
5. Generate noise-only trials and estimate $P_{FA}$.
6. Generate signal-plus-noise trials and estimate $P_D$.
7. Plot both ROC curves on one figure and save the image.

## Proposed File List
- `main_problem_2_1.m`
- `compute_theoretical_roc.m`
- `simulate_energy_detector_roc.m`

## Implementation Style Note
The code should follow the live lab style:

- simple
- short
- minimal comments
- no heavy input checking
- no over-engineering

## Verification Strategy
- Check that all probabilities remain in $[0,1]$.
- Check that the threshold range spans low and high false-alarm regions.
- Check that the simulated ROC follows the same overall trend as the theoretical ROC.
- Check that the same $\sigma_n$ is used in the theoretical path and in both simulation cases.

## Expected Plots / Tables
- One ROC overlay figure
- One short report summarizing parameters, equations, and the result

## Open Questions / Review Items
- Once the documentation and plot are approved, no further structural changes should be needed before submission.
