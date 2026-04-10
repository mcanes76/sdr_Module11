clear
close all
clc

payload_length = 192;
crc_length = 16;
packet_length = 208;
coded_length = 364;
snr_dB_vec = 0:12;
num_trials = 20000;

per_uncoded = zeros(size(snr_dB_vec));
per_coded = zeros(size(snr_dB_vec));
acc_uncoded = zeros(size(snr_dB_vec));
acc_coded = zeros(size(snr_dB_vec));

for snr_idx = 1:length(snr_dB_vec)
    snr_dB = snr_dB_vec(snr_idx);

    packet_errors_uncoded = 0;
    packet_errors_coded = 0;
    payload_accuracy_uncoded = 0;
    payload_accuracy_coded = 0;

    for trial_idx = 1:num_trials
        payload_bits = randi([0 1], 1, payload_length);

        [packet_error_uncoded, payload_bit_accuracy_uncoded] = ...
            run_per_trial_uncoded(payload_bits, snr_dB);

        [packet_error_coded, payload_bit_accuracy_coded] = ...
            run_per_trial_coded(payload_bits, snr_dB);

        packet_errors_uncoded = packet_errors_uncoded + packet_error_uncoded;
        packet_errors_coded = packet_errors_coded + packet_error_coded;
        payload_accuracy_uncoded = payload_accuracy_uncoded + payload_bit_accuracy_uncoded;
        payload_accuracy_coded = payload_accuracy_coded + payload_bit_accuracy_coded;
    end

    per_uncoded(snr_idx) = packet_errors_uncoded / num_trials;
    per_coded(snr_idx) = packet_errors_coded / num_trials;
    acc_uncoded(snr_idx) = payload_accuracy_uncoded / num_trials;
    acc_coded(snr_idx) = payload_accuracy_coded / num_trials;
end

helper_plot_per_accuracy(snr_dB_vec, per_uncoded, per_coded, acc_uncoded, acc_coded, num_trials)

save('problem_2_2_results.mat', 'payload_length', 'crc_length', 'packet_length', ...
    'coded_length', 'snr_dB_vec', 'num_trials', 'per_uncoded', 'per_coded', ...
    'acc_uncoded', 'acc_coded')

disp('SNR_dB    PER_uncoded    PER_coded    ACC_uncoded    ACC_coded')
for idx = 1:length(snr_dB_vec)
    fprintf('%5.0f    %11.6f    %9.6f    %11.6f    %9.6f\n', ...
        snr_dB_vec(idx), per_uncoded(idx), per_coded(idx), ...
        acc_uncoded(idx), acc_coded(idx));
end
