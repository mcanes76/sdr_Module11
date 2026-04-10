clear
close all
clc

SNR_dB = -3;
measurement_length = 32;
threshold_base = 0.1:0.1:20;
threshold_range = threshold_base * measurement_length;
sigma_n = 1;
num_trials = 100000;

SNR_linear = 10^(SNR_dB/10);
signal_amplitude = sqrt(2*sigma_n^2*SNR_linear);

[falsealarmvec_endet_th, posdetvec_endet_th] = ...
    compute_theoretical_roc(threshold_range, measurement_length, sigma_n, signal_amplitude);

[falsealarmvec_endet_sim, posdetvec_endet_sim] = ...
    simulate_energy_detector_roc(threshold_range, measurement_length, sigma_n, signal_amplitude, num_trials);

figure
plot(falsealarmvec_endet_sim, posdetvec_endet_sim, '-o')
hold on
plot(falsealarmvec_endet_th, posdetvec_endet_th, '-x')
hold off
xlabel('Probability of False Alarm')
ylabel('Probability of Detection')
legend('Simulated ROC', 'Theoretical ROC')
grid on
