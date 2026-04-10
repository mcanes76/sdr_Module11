function [falsealarmvec_endet_sim, posdetvec_endet_sim] = ...
    simulate_energy_detector_roc(threshold_range, measurement_length, sigma_n, signal_amplitude, num_trials)

noise_only = sigma_n * (randn(measurement_length, num_trials) + ...
    1i*randn(measurement_length, num_trials));

signal_plus_noise = signal_amplitude + sigma_n * ...
    (randn(measurement_length, num_trials) + 1i*randn(measurement_length, num_trials));

decision_metrics_noise = sum(abs(noise_only).^2, 1);
decision_metrics_signal = sum(abs(signal_plus_noise).^2, 1);

falsealarmvec_endet_sim = zeros(size(threshold_range));
posdetvec_endet_sim = zeros(size(threshold_range));

for idx = 1:length(threshold_range)
    eta = threshold_range(idx);

    falsealarmvec_endet_sim(idx) = ...
        sum(decision_metrics_noise > eta) / num_trials;

    posdetvec_endet_sim(idx) = ...
        sum(decision_metrics_signal > eta) / num_trials;
end

end
