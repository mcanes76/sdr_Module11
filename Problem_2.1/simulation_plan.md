# Problem 2.1: ROC for Energy Detector Simulation Plan

**Pending review - not yet executed.**

Documentation generated for review only. No scripts or simulations have been executed.

## Goal of the Simulation
Prepare an implementation plan for generating both theoretical and Monte Carlo ROC curves for a 32-sample energy detector at `SNR = -3 dB`, then overlaying the two results for validation.

## Step-by-Step Execution Plan
1. Define a parameter block containing `L = 32`, `SNR = -3 dB`, noise variance convention, threshold vector, and Monte Carlo trial count.
2. Convert SNR to a linear ratio and map it to signal amplitude using the agreed noise-power convention.
3. Build a threshold vector scaled by measurement length, such as `L` times a normalized sweep.
4. Compute the theoretical ROC using the live-lab formulas for $P_{fa}$ and $P_d$.
5. Run a noise-only Monte Carlo branch to estimate $P_{fa}$ for each threshold.
6. Run a signal-plus-noise Monte Carlo branch to estimate $P_d$ for each threshold.
7. Overlay the simulated and theoretical ROC curves on one figure.
8. Record any mismatch metrics and review whether the threshold span and trial count are adequate.

## Proposed File List to Implement Later
- `main_problem_2_1.m`
- `compute_theoretical_roc.m`
- `simulate_energy_detector_roc.m`
- `generate_complex_awgn.m`
- `helper_plot_roc.m`

## Parameter Table
| Parameter | Proposed Value / Role | Notes |
|---|---|---|
| Measurement length `L` | `32` | Assignment requirement |
| SNR | `-3 dB` | Assignment requirement |
| Threshold vector | `L`-scaled sweep | Must cover low and high ROC regions |
| Noise model | Complex AWGN | Follows live-lab pattern |
| Monte Carlo trials | Configurable, start high enough for stable tails | Exact value to confirm before coding |
| Signal model | Deterministic complex amplitude plus AWGN | Needs final review confirmation |

## Verification Strategy
- Check that all estimated probabilities remain in $[0,1]$.
- Check that the ROC trend is physically valid: as threshold increases, $P_{fa}$ and $P_d$ should not increase.
- Check that simulated and theoretical curves are reasonably close over the full sweep.
- Check that the threshold vector is broad enough to produce both near-zero and near-one probability regions.
- Check that simulation results converge when the trial count is increased.

## Expected Plots / Tables
- ROC overlay figure with theoretical and simulated curves.
- Optional table summarizing selected threshold points and associated $(P_{fa}, P_d)$ values.
- Optional summary metric such as maximum absolute curve deviation.

## Corner Cases and Sanity Checks
- Very small thresholds should drive both $P_{fa}$ and $P_d$ toward one.
- Very large thresholds should drive both $P_{fa}$ and $P_d$ toward zero.
- If simulated $P_d$ falls below simulated $P_{fa}$ across most of the sweep, the signal-power normalization is likely wrong.
- If theory and simulation disagree systematically, verify complex-noise normalization and threshold scaling first.

## Review Checklist Before Coding
- Confirm the exact signal model under $H_1$.
- Confirm the SNR convention to be used in code and in report text.
- Confirm the initial Monte Carlo trial count target.
- Confirm whether the final deliverable needs only the ROC overlay or also diagnostic plots.
- Confirm whether helper functions should live directly in `Problem_2.1` or within a subfolder.

## Open Questions / Review Items
- Should the threshold sweep be linear, logarithmic, or hand-tuned to emphasize the ROC knees?
- Should the simulation store raw decision metrics for optional debugging plots, or only aggregate probabilities?
- Is $\mathrm{marcumq}$ assumed available in the target MATLAB environment, or should a fallback plan be documented before coding?
