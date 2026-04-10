# Problem 2.1: ROC for Energy Detector

**Do not execute until reviewed.**

Documentation generated for review only. No scripts or simulations have been executed.

## Purpose / Assignment Intent
Build theoretical and simulated ROC curves for an energy detector at `SNR = -3 dB` using measurement length `K = 32` complex samples. The main deliverable is an overlay plot comparing theory and simulation over the same threshold sweep.

## Requirements Summary
The assignment uses an energy detector with decision metric formed over `K = 32` samples. Both the theoretical ROC and the Monte Carlo ROC should be computed using the same threshold vector. False alarm must be measured with noise-only trials, and detection must be measured with signal-plus-noise trials using the same noise variance in both cases.

For this problem, the threshold vector is defined as:

$$
\texttt{threshold\_base} = 0.1:0.1:20
$$

$$
\texttt{threshold\_range} = \texttt{threshold\_base} \cdot K
$$

## Inputs and Outputs
### Inputs
- Measurement length `K = 32`
- SNR value `-3 dB`
- Noise standard deviation $\sigma_n$
- Threshold vector $\eta$
- Number of Monte Carlo trials

### Outputs
- Theoretical $P_{FA}$ and $P_D$ arrays
- Simulated $P_{FA}$ and $P_D$ arrays
- ROC overlay plot

## Assumptions and Interpretation Notes
The existing repository uses `Problem_2.1`, so this documentation follows that folder naming. The live lab style suggests a simple complex-baseband model, a direct threshold sweep, and short scripts with minimal abstraction.

The detector should use the same threshold vector for both the theoretical and simulated paths. The simulation should use noise-only trials to estimate false alarm and signal-plus-noise trials to estimate detection, with the same noise variance in both tests.

## Proposed Software Architecture
Keep the structure simple:

- A theoretical ROC path computes $P_{FA}$ and $P_D$ from the closed-form equations.
- A simulated ROC path estimates $P_{FA}$ and $P_D$ using Monte Carlo trials.
- A main script defines shared parameters and calls both paths.

This keeps the implementation aligned with the live lab and avoids over-engineering.

## Functional Decomposition into MATLAB Scripts/Functions
- `main_problem_2_1.m`
  Defines `K`, SNR, threshold vector, and trial count, then calls the two ROC paths.
- `compute_theoretical_roc.m`
  Computes theoretical $P_{FA}$ and $P_D$ over the threshold vector.
- `simulate_energy_detector_roc.m`
  Simulates noise-only and signal-plus-noise trials over the same threshold vector.

## Data Flow
1. Define `K = 32`, SNR, noise level, and the threshold vector.
2. Compute the theoretical ROC over the full threshold range.
3. Simulate noise-only trials to estimate $P_{FA}$.
4. Simulate signal-plus-noise trials to estimate $P_D$.
5. Overlay theoretical and simulated ROC curves.

## Key Formulas and Algorithm Notes
The decision metric is

$$
T = \sum_{n=1}^{K} |r[n]|^2
$$

The markdown renderer may not display special decision operators reliably, so the decision rule is written explicitly in words:

Decide $H_1$ if $T > \eta$; otherwise decide $H_0$.

From the textbook form, the probability of missed detection is

$$
P_{MD} = 1 - Q_K\!\left(\frac{\sqrt{E_s}}{\sigma_n},\, \frac{\sqrt{\eta}}{\sigma_n}\right)
$$

Therefore, the probability of detection is

$$
P_D = Q_K\!\left(\frac{\sqrt{E_s}}{\sigma_n},\, \frac{\sqrt{\eta}}{\sigma_n}\right)
$$

The probability of false alarm is

$$
P_{FA} = \Gamma\!\left(K,\, \frac{\eta}{2\sigma_n^2}\right)
$$

where $\Gamma(K, x)$ denotes the normalized upper incomplete gamma function.

In the MATLAB form used by the live lab, these become

$$
P_{FA} = \mathrm{gammainc}\!\left(\frac{\eta}{2\sigma_n^2},\, K,\, \text{upper}\right)
$$

$$
P_D = \mathrm{marcumq}\!\left(\frac{\sqrt{E_s}}{\sigma_n},\, \frac{\sqrt{\eta}}{\sigma_n},\, K\right)
$$

For a constant-amplitude signal, a common simplification is

$$
E_s = |A|^2 K
$$

which gives

$$
P_D = \mathrm{marcumq}\!\left(\frac{|A|\sqrt{K}}{\sigma_n},\, \frac{\sqrt{\eta}}{\sigma_n},\, K\right)
$$

For the simulation notes, use

$$
\mathrm{SNR}_{\text{linear}} = 10^{\mathrm{SNR}_{dB}/10}
$$

and, for a simple complex-baseband model,

$$
\mathrm{SNR} = \frac{|A|^2}{2\sigma_n^2}
$$

so if $\sigma_n$ is chosen first,

$$
A = \sqrt{2\sigma_n^2 \cdot \mathrm{SNR}_{\text{linear}}}
$$

## Plot / Report Deliverables Expected
- ROC overlay plot comparing theoretical and simulated curves
- Brief parameter summary listing `K`, SNR, threshold vector, and trial count

## Risks / Validation Concerns
The main risk is inconsistent normalization between the theoretical and simulated paths. In particular, the mapping from SNR to amplitude should match the same $\sigma_n$ used in both the noise-only and signal-plus-noise trials.

The threshold vector must also be scaled by measurement length as specified. If that scaling is skipped, the ROC comparison will not match the intended assignment setup.

## Open Questions / Review Items
- Confirm that the constant-amplitude signal model is acceptable for the simulation.
- Confirm the preferred Monte Carlo trial count before coding.
- Once this documentation is approved, MATLAB code generation can begin.
