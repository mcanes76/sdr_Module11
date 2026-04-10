# Problem 2.3: Noise Estimation Simulation Plan

**Pending review - not yet executed.**

Documentation generated for review only. No scripts or simulations have been executed.

## Goal of the Simulation
Prepare an implementation plan for estimating noise variance from four OTA capture files using the eigenvalue/MDL method, then comparing the estimates to provided truth data with a target relative error below `5%`.

## Step-by-Step Execution Plan
1. Define a driver script that iterates through all four OTA capture files.
2. For each file, load the captured data and the associated truth noise variable.
3. Choose an observation length and derive the number of usable observations.
4. Reshape the capture into an observation matrix with one observation per column.
5. Compute the sample covariance matrix.
6. Compute and sort covariance eigenvalues in descending order.
7. Evaluate the corrected MDL objective across valid `k` values.
8. Select the minimizing `k` and identify the noise subspace.
9. Estimate noise power as the mean of the trailing eigenvalues.
10. Compute relative error against the truth value.
11. Report results for each file and optionally generate diagnostic plots.

## Proposed File List to Implement Later
- `main_problem_2_3.m`
- `EstimateNoise.m`
- `calcKMin.m`
- `build_covariance_matrix.m`
- `helper_plot_eigenvalues.m`

## Parameter Table
| Parameter | Proposed Value / Role | Notes |
|---|---|---|
| Capture files | `OTA_Capture1.mat` to `OTA_Capture4.mat` | Already present in repo |
| Observation length `M` | Configurable | Must be reviewed before coding |
| Number of observations `N_{obs}` | Derived from data length | May require truncation if not exact |
| Eigenvalue order | Descending sort | Matches live-lab style |
| MDL equation | Corrected homework version | Must override older variants |
| Diagnostics | Optional eigenvalue and MDL plots | Useful for review |

## Verification Strategy
- Check that the estimated noise power is positive for every capture.
- Check that the selected $k$ lies in a valid range $0 \le k < M$.
- Check that the covariance matrix dimensions agree with the chosen observation length.
- Check that relative error is computed as
  $$
  \frac{|\hat{\sigma}_n^2 - \sigma_{n,\text{truth}}^2|}{\sigma_{n,\text{truth}}^2}
  $$
- Check that data reshaping handles non-integer multiples of the observation length explicitly.
- Check whether the target relative error below `5%` is met consistently across all captures.

## Expected Plots / Tables
- Summary table listing capture name, estimated noise power, truth noise power, selected `k`, and relative error.
- Optional sorted-eigenvalue plot for each capture.
- Optional MDL objective versus `k` plot for each capture.

## Corner Cases and Sanity Checks
- If all eigenvalues are nearly equal, the algorithm should still return a valid low-signal-subspace estimate.
- If one or more dominant eigenvalues are present, `k` should not collapse to an invalid value.
- If the capture length is shorter than the proposed observation length times a useful number of observations, the script should reduce or reselect parameters rather than forcing a poor reshape.
- If the estimated noise power exceeds all eigenvalues or becomes nonpositive, inspect covariance scaling and eigenvalue handling immediately.

## Review Checklist Before Coding
- Confirm the corrected MDL equation from the homework PDF.
- Confirm the intended observation length and whether one value should be reused for all captures.
- Confirm the variable names expected inside each `.mat` file.
- Confirm whether the existing live-lab `calcKMin.m` should be reused or whether a local assignment-specific version is preferred.
- Confirm whether diagnostic plots are desired in the final submission or only for internal validation.

## Open Questions / Review Items
- Should the observation length be selected heuristically, fixed from the live lab, or justified analytically?
- Should `EstimateNoise` return only the scalar estimate or also a metadata struct containing `k`, eigenvalues, and reshape details?
- Should the driver save any result artifacts later, or remain print-only for a minimal assignment submission?
