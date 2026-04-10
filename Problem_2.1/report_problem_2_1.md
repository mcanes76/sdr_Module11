# Problem 2.1 Report

## Objective
Compute and compare the theoretical and simulated ROC curves for an energy detector using `SNR_dB = -3` and measurement length `K = 32`.

## Parameters Used
- `SNR_dB = -3`
- `K = 32`
- `sigma_n = 1`
- `num_trials = 100000`
- `threshold_base = 0.1:0.1:20`
- `threshold_range = threshold_base * K`
- Run-time signal amplitude:

$$
A = 0.70795
$$

## Equations Used
Decision metric:

$$
T = \sum_{n=1}^{K} |r[n]|^2
$$

Decision rule:

Decide $H_1$ if $T > \eta$; otherwise decide $H_0$.

Theoretical false alarm probability:

$$
P_{FA} = \mathrm{gammainc}\!\left(\frac{\eta}{2\sigma_n^2},\, K,\, \text{upper}\right)
$$

Theoretical detection probability:

$$
P_D = \mathrm{marcumq}\!\left(\frac{|A|\sqrt{K}}{\sigma_n},\, \frac{\sqrt{\eta}}{\sigma_n},\, K\right)
$$

SNR mapping:

$$
\mathrm{SNR}_{\text{linear}} = 10^{\mathrm{SNR}_{dB}/10}
$$

$$
A = \sigma_n \sqrt{\mathrm{SNR}_{\text{linear}}}
$$

## Method Summary
The theoretical ROC was computed directly from the MATLAB `gammainc` and `marcumq` expressions over the full threshold vector.

The simulated ROC used Monte Carlo trials with complex AWGN generated as

$$
n = \frac{\sigma_n}{\sqrt{2}}\left(n_I + j n_Q\right)
$$

so that the total complex noise power satisfies $E[|n|^2] = \sigma_n^2$. False alarm was estimated using noise-only trials, and detection was estimated using constant-amplitude signal-plus-noise trials.

## ROC Figure
![Problem 2.1 ROC](roc_problem_2_1.png)

## Result
The script executed successfully and generated the ROC figure. The simulated ROC should track the theoretical ROC closely, with small Monte Carlo variation due to the finite trial count.
