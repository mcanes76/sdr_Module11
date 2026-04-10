function [packet_error, payload_bit_accuracy] = run_per_trial_coded(payload_length, snr_dB)

payload_bits = randi([0 1], 1, payload_length);
packet_bits = append_crc16(payload_bits);
coded_bits = hamming74_encode_packet(packet_bits);

tx_symbols = bpsk_modulate_bits(coded_bits);

snr_linear = 10^(snr_dB/10);
code_rate = 4/7;
noise_sigma = sqrt(1/(2*code_rate*snr_linear));
rx_symbols = tx_symbols + noise_sigma*randn(size(tx_symbols));

hard_bits = bpsk_demod_hard(rx_symbols);
recovered_packet = hamming74_decode_packet_hard(hard_bits);
[crc_pass, recovered_payload] = check_crc16(recovered_packet);

packet_error = double(~crc_pass);
payload_bit_accuracy = mean(recovered_payload == payload_bits);

end
