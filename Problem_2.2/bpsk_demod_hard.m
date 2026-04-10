function hard_bits = bpsk_demod_hard(rx_symbols)

hard_bits = double(rx_symbols >= 0);

end
