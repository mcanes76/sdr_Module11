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

The payload bit accuracy metric is the fraction of the original 192-bit truth payload recovered correctly after receiver processing. Packet error rate is defined by CRC failure after receiver processing.

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

Payload bit accuracy also improves with SNR for both branches. At low SNR the uncoded branch shows slightly higher payload bit accuracy due to the rate loss of the Hamming code. As SNR increases, the Hamming decoder begins correcting single-bit errors, and the payload accuracy of both systems converges to nearly identical values. For example, at `7 dB` the uncoded payload accuracy was `0.999234` while the coded payload accuracy was `0.999362`.

The accuracy plot reports the fraction of the original 192 payload bits recovered correctly relative to the truth data. This metric can remain close to 1 even when packet error rate is still noticeable, because CRC declares a packet failure if any residual error remains after receiver processing. As a result, the PER plot is the more sensitive measure of end-to-end packet reliability, while the truth-payload-accuracy plot shows the overall bit-correctness trend.

## Figures
![PER Plot](problem_2_2_per.png)

![Accuracy Plot](problem_2_2_accuracy.png)

## Short Discussion
Hamming coding improves reliability in the moderate-SNR region by adding redundancy before transmission. In this simulation, packet error rate is defined by CRC failure, and hard-decision demodulation and hard Hamming decoding were used throughout. The coded branch shows the expected PER improvement once the SNR is high enough for the error-correcting code to help more than the added redundancy hurts.

Because the Hamming(7,4) code expands the 208-bit packet to 364 transmitted bits, the coded system initially experiences a reduction in effective energy per transmitted bit. As a result, the uncoded system shows slightly higher payload bit accuracy at very low SNR before the error-correction capability of the code becomes beneficial.