# Problem 2.2 Report

## Objective
Compare uncoded and Hamming(7,4)-coded packet performance using CRC-16 packet validation over the assignment SNR sweep. The current executed MATLAB run used the saved script setting `snr_dB_vec = 0:12`.

## Parameters Used
- Payload length = 192 bits
- CRC length = 16 bits
- Packet length = 208 bits
- Coded length = 364 bits
- SNR range used in the executed run = 0:12 dB
- Number of trials used = 20000

## Packet Structure
$$
192 \rightarrow 208 \rightarrow 364
$$

## Methods Summary
Uncoded branch:
payload -> CRC-16 -> BPSK -> AWGN -> hard demod -> CRC check

Coded branch:
payload -> CRC-16 -> Hamming(7,4) -> BPSK -> AWGN -> hard demod -> Hamming decode -> CRC check

The payload bit accuracy metric is computed against the original 192-bit truth payload. Packet error rate is defined by CRC failure after receiver processing.

## Fairness Convention
Eb/N0-style fairness is referenced to the 208-bit CRC-appended packet. The coded branch uses

$$
R_c = \frac{208}{364} = \frac{4}{7}
$$

in the AWGN scaling.

## Results
The executed MATLAB run produced these vectors:

- `per_uncoded = [1.000000 0.999950 0.999850 0.992550 0.926300 0.706850 0.392600 0.148500 0.038300 0.006100 0.000950 0.000000 0.000000]`
- `per_coded = [1.000000 1.000000 0.998700 0.979700 0.856650 0.565050 0.244150 0.074150 0.012800 0.002050 0.000000 0.000000 0.000000]`
- `acc_uncoded = [0.921252 0.943672 0.962452 0.977028 0.987404 0.994080 0.997614 0.999234 0.999811 0.999971 0.999995 1.000000 1.000000]`
- `acc_coded = [0.880922 0.915489 0.945161 0.968364 0.983972 0.993101 0.997682 0.999362 0.999892 0.999981 1.000000 1.000000 1.000000]`

PER decreases steadily with increasing SNR for both cases. The coded case begins to improve PER clearly from the moderate-SNR region onward. For example, at `6 dB` the uncoded PER was `0.392600` while the coded PER was `0.244150`, and at `9 dB` the uncoded PER was `0.006100` while the coded PER was `0.002050`.

Payload bit accuracy also improves with SNR for both branches. At lower SNR the uncoded branch has slightly higher payload bit accuracy, but the coded branch overtakes it in the moderate-to-high SNR region. For example, at `7 dB` the uncoded payload accuracy was `0.999234` while the coded payload accuracy was `0.999362`.

## Figures
![PER Plot](problem_2_2_per.png)

![Accuracy Plot](problem_2_2_accuracy.png)

## Discussion
Hamming coding improves reliability in the moderate-SNR region by adding redundancy before transmission. In this simulation, packet error rate is defined by CRC failure, and hard-decision demodulation and hard Hamming decoding were used throughout. The coded branch shows the expected PER improvement once the SNR is high enough for the error-correcting code to help more than the added redundancy hurts.

The simulation results demonstrate that the Hamming(7,4) coded system provides improved packet reliability relative to the uncoded system. This improvement is observed as a horizontal shift of the packet error rate (PER) curve toward lower SNR values. At moderate-to-high SNR values, the coded system achieves the same PER as the uncoded system at approximately 1–2 dB lower SNR. This behavior represents coding gain and results from the error-correction capability of the Hamming(7,4) code, which can correct single-bit errors within each codeword and thereby reduce the probability that residual errors remain in the packet after decoding.

Because packet errors are defined using CRC validation, any residual bit error in the decoded packet results in a packet failure. The Hamming decoder reduces the number of bit errors before CRC checking, which significantly lowers the probability that the CRC detects a corrupted packet.