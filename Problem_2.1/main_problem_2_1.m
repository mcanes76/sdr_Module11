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
signal_amplitude = sigma_n * sqrt(SNR_linear);

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
legend('Energy Detector Simulation', 'Energy Detector Theory', 'Location', 'southeast')
grid on
axis([0 1 0 1])
ax = gca;
ax.Toolbar.Visible = 'off';
exportgraphics(gcf, 'roc_problem_2_1.png', 'Resolution', 150)

disp(['SNR_dB = ', num2str(SNR_dB)])
disp(['measurement_length = ', num2str(measurement_length)])
disp(['sigma_n = ', num2str(sigma_n)])
disp(['signal_amplitude = ', num2str(signal_amplitude)])
