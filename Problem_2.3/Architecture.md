# Problem 2.3: Noise Variance Estimation via MDL

**Do not execute until reviewed.**

Documentation generated for review only. No scripts or simulations have been executed.

## Purpose / Assignment Intent
Design a noise-power estimation workflow for the provided OTA captures using the eigenvalue/MDL method discussed in lecture and the live lab. The required structure is an `EstimateNoise(captured_data)` function plus a driver script that processes all four captures and reports relative error against provided truth.

## Requirements Summary
### Assignment Requirement
- Build around an `EstimateNoise(captured_data)` interface.
- Load all four provided OTA captures.
- Estimate noise power from each capture using the MDL/eigenvalue approach.
- Report relative error for each capture.
- Note and use the corrected MDL equation from the homework.
- Target relative error below `5%`.

### Implementation Proposal
- Follow the live-lab approach:
  - reshape raw data into an observation matrix,
  - compute a sample covariance matrix,
  - compute and sort eigenvalues,
  - estimate signal-subspace dimension `k` using MDL,
  - average trailing eigenvalues to estimate noise power.
- Reuse the existing `Lab11_scripts/calcKMin.m` logic as a reference, but keep any assignment implementation local to `Problem_2.3` unless later review approves a shared dependency.

## Inputs and Outputs
### Inputs
- `captured_data` vector or matrix from each OTA capture file.
- Observation length and number of observations derived from the data shape.
- MDL criterion parameters based on sorted eigenvalues, number of observations, and samples per observation.

### Outputs
- Estimated noise power for each capture.
- Estimated `k` or equivalent signal-subspace dimension.
- Relative error against the provided truth variable.
- Optional diagnostic data such as eigenvalue spectra and MDL objective values.

## Assumptions and Interpretation Notes
- The repository already contains `OTA_Captures/OTA_Capture1.mat` through `OTA_Capture4.mat`.
- The exact variable names inside those `.mat` files were not inspected here because the local Python environment lacks common MAT-file readers and MATLAB execution is intentionally deferred. The implementation should inspect variable names at coding time.
- The live-lab script uses a covariance estimate of the form
  $$
  \mathbf{R} = \frac{\mathbf{X}\mathbf{X}^H}{N_{obs}-1}
  $$
  where columns of `\mathbf{X}` are observations.
- The existing `calcKMin.m` returns the minimizing index `kMin` after evaluating an MDL-style objective over possible signal-subspace dimensions.
- The corrected homework equation takes precedence over any live-lab or legacy expression if they differ.

## Proposed Software Architecture
The design should use a thin driver script and one core estimator function. The driver handles file loading, reporting, and optional visualization. The estimator handles all signal-processing logic and exposes a clean interface suitable for independent testing later.

Within `EstimateNoise`, the workflow should be:
1. sanitize and reshape input samples into an observation matrix,
2. compute the covariance matrix,
3. compute eigenvalues,
4. sort eigenvalues in descending order,
5. evaluate MDL over feasible `k`,
6. identify the minimizing `k`,
7. average the trailing eigenvalues corresponding to the noise subspace.

## Functional Decomposition into MATLAB Scripts/Functions
- `main_problem_2_3.m`
  Loads each capture, calls `EstimateNoise`, computes relative error, and reports results.
- `EstimateNoise.m`
  Core noise estimator operating on one capture at a time.
- `calcKMin.m`
  Local or reused MDL helper that returns the minimizing `k`.
- `build_covariance_matrix.m`
  Encapsulates reshape and covariance operations for clarity.
- `helper_plot_eigenvalues.m`
  Optional diagnostic plot for sorted eigenvalues and possibly MDL objective values.

## Data Flow
1. Driver loads one capture file.
2. Driver extracts `captured_data` and the provided truth noise variable.
3. Driver calls `EstimateNoise(captured_data)`.
4. `EstimateNoise` reshapes data into observations and builds the sample covariance matrix.
5. `EstimateNoise` computes and sorts eigenvalues.
6. `EstimateNoise` calls `calcKMin` using sorted eigenvalues, number of observations, and observation length.
7. `EstimateNoise` averages the noise-subspace eigenvalues to form the estimate.
8. Driver computes relative error and prints or stores the result.
9. Repeat for all four capture files.

## Key Formulas and Algorithm Notes
### Covariance and Eigenstructure
$$
\mathbf{R} = \frac{\mathbf{X}\mathbf{X}^H}{N_{obs}-1}
$$
$$
\lambda_1 \ge \lambda_2 \ge \dots \ge \lambda_M
$$
where `M` is the observation length and the eigenvalues are sorted in descending order.

### MDL Structure
For each candidate signal-subspace dimension $k$, compute the geometric and arithmetic means of the trailing eigenvalues:
$$
\phi_k = \left(\prod_{i=k+1}^{M}\lambda_i\right)^{1/(M-k)}
$$
$$
\theta_k = \frac{1}{M-k}\sum_{i=k+1}^{M}\lambda_i
$$
and evaluate the corrected homework MDL criterion. The implementation must verify the exact homework expression before coding and use that version as authoritative.

### Noise Estimate
Once $k$ is selected,
$$
\hat{\sigma}_n^2 = \frac{1}{M-k}\sum_{i=k+1}^{M}\lambda_i
$$
which is the average of the noise-subspace eigenvalues.

## Plot / Report Deliverables Expected
- Per-capture printed estimate and relative error.
- Summary table across all four OTA captures.
- Optional diagnostic plots:
  - sorted eigenvalue spectrum,
  - MDL objective versus `k`.

## Risks / Validation Concerns
- The corrected homework MDL equation must be confirmed before implementation; using an outdated expression could shift the chosen `k`.
- Observation length selection can materially affect covariance quality and eigenvalue separation.
- If the capture length is not an integer multiple of the observation length, truncation or reshaping policy must be documented explicitly.
- Variable naming inside the `.mat` files is not yet confirmed and may require a small loading adapter.
- Plot generation inside the existing `Lab11_scripts/calcKMin.m` may be undesirable for a clean assignment solution unless intentionally preserved.

## Open Questions / Review Items
- Confirm the exact corrected MDL equation text from the homework before coding.
- Confirm the intended observation length and whether it should match a live-lab default or be tuned per capture.
- Confirm whether `calcKMin.m` should be reused directly, copied locally, or reimplemented cleanly in `Problem_2.3`.
- Confirm the expected output format for the reported relative errors.
