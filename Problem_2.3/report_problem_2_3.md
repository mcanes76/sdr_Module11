# Problem 2.3 Report

## Objective
Estimate the noise power of the four provided OTA captures using the MDL-eigenvalue method and compare each estimate against the provided truth noise power.

## Method Summary
The implementation follows the live-lab style interface `EstimateNoise(captured_data)`. Each capture is reshaped into an observation matrix using a fixed observation length of `64` samples. The sample covariance matrix is formed, its eigenvalues are computed and sorted in descending order, and the corrected homework MDL equation is evaluated over all candidate values of `k`.

The implementation used the corrected homework form of Equation 5.20, in which the two MDL terms are summed before minimizing over 𝑘.

The minimizing `k` is used to define the noise subspace, and the final noise estimate is computed as the mean of the trailing eigenvalues.

## Observation Length
- Observation length used: `64`

## Results
| Capture | Estimated Noise | True Noise | Relative Error | k |
|--------|--------|--------|--------|--------|
| OTA_Capture1.mat | 0.098514 | 0.100000 | 0.014859 | 6 |
| OTA_Capture2.mat | 0.493408 | 0.500000 | 0.013184 | 4 |
| OTA_Capture3.mat | 0.048740 | 0.050000 | 0.025195 | 10 |
| OTA_Capture4.mat | 0.319793 | 0.333333 | 0.040620 | 9 |

## Requirement Check
All four captures satisfied the relative error requirement of `< 5%`.

## Diagnostic Figures
![Sorted Eigenvalues](problem_2_3_eigenvalues.png)

![MDL Curve](problem_2_3_mdl.png)
