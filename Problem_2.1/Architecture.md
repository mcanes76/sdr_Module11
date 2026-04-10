# Problem 2.1: ROC for Energy Detector

**Documentation updated for implementation review.**

## Purpose / Assignment Intent
Problem 2.1 compares theoretical and simulated ROC curves for an energy detector at `SNR = -3 dB` using measurement length `K = 32` complex samples. The same threshold vector is used for both paths so the ROC overlay is directly comparable.

## Requirements Summary
The detector uses the energy in one measurement window as its decision statistic. The theoretical ROC is computed from the textbook expressions in MATLAB form, and the simulated ROC is computed with Monte Carlo trials.

The threshold vector is

$$
\texttt{threshold\_base} = 0.1:0.1:20
$$

$$
\texttt{threshold\_range} = \texttt{threshold\_base} \cdot K
$$

False alarm is estimated from noise-only trials. Detection is estimated from signal-plus-noise trials. Both use the same complex noise variance.

## Inputs and Outputs
### Inputs
- Measurement length `K = 32`
- SNR value `-3 dB`
- Total complex noise standard deviation $\sigma_n$
- Threshold vector $\eta$
- Number of Monte Carlo trials

### Outputs
- Theoretical $P_{FA}$ and $P_D$
- Simulated $P_{FA}$ and $P_D$
- ROC plot saved to file

## Assumptions and Interpretation Notes
This problem uses a simple complex-baseband model consistent with the live lab. The notation $\sigma_n$ is treated as the total complex noise standard deviation in both the theory and simulation, with

$$
E[|n|^2] = \sigma_n^2
$$

To match that convention in simulation, complex AWGN is generated as

$$
n = \frac{\sigma_n}{\sqrt{2}}\left(n_I + j n_Q\right)
$$

where `randn` is used for both real branches. This gives each branch variance $\sigma_n^2/2$, so the total complex noise power is $\sigma_n^2$.

The detector uses the same threshold vector for the theoretical and simulated ROC paths, noise-only trials for false alarm, and signal-plus-noise trials for detection.

## Proposed Software Architecture
Keep the implementation simple and close to the live lab:

- `main_problem_2_1.m` defines parameters, calls both ROC paths, and makes the plot.
- `compute_theoretical_roc.m` computes the theoretical ROC.
- `simulate_energy_detector_roc.m` computes the simulated ROC.

## Data Flow
1. Define `K`, SNR, `threshold_range`, `\sigma_n`, and `num_trials`.
2. Convert SNR from dB to linear scale.
3. Compute the constant signal amplitude from the chosen $\sigma_n$.
4. Compute theoretical $P_{FA}$ and $P_D$.
5. Simulate noise-only trials for $P_{FA}$.
6. Simulate signal-plus-noise trials for $P_D$.
7. Plot and save the ROC figure.

## Key Formulas and Algorithm Notes
The decision metric is

$$
T = \sum_{n=1}^{K} |r[n]|^2
$$

The markdown renderer may not display special decision operators reliably, so the decision rule is written in words:

Decide $H_1$ if $T > \eta$; otherwise decide $H_0$.

Theoretical false alarm probability:

$$
P_{FA} = \mathrm{gammainc}\!\left(\frac{\eta}{2\sigma_n^2},\, K,\, \text{upper}\right)
$$

Theoretical detection probability:

$$
P_D = \mathrm{marcumq}\!\left(\frac{\sqrt{E_s}}{\sigma_n},\, \frac{\sqrt{\eta}}{\sigma_n},\, K\right)
$$

For a constant-amplitude signal,

$$
E_s = |A|^2 K
$$

so

$$
P_D = \mathrm{marcumq}\!\left(\frac{|A|\sqrt{K}}{\sigma_n},\, \frac{\sqrt{\eta}}{\sigma_n},\, K\right)
$$

For simulation,

$$
\mathrm{SNR}_{\text{linear}} = 10^{\mathrm{SNR}_{dB}/10}
$$

and

$$
\mathrm{SNR}_{\text{linear}} = \frac{|A|^2}{\sigma_n^2}
$$

therefore

$$
A = \sigma_n \sqrt{\mathrm{SNR}_{\text{linear}}}
$$

## Plot / Report Deliverables Expected
- ROC overlay plot with simulated and theoretical curves
- Short markdown report summarizing the setup and result

## Risks / Validation Concerns
The main point to keep consistent is the noise convention. The theoretical expressions and the simulation must use the same definition of $\sigma_n$, and the complex AWGN generation must include the $\sqrt{2}$ scaling so that the total complex noise power remains $\sigma_n^2$.

The threshold vector must also remain scaled by `K` as required by the assignment.

## Open Questions / Review Items
- Confirm whether any additional annotation is needed on the final plot.
- Confirm whether the current simple constant-amplitude signal model is sufficient for submission.
