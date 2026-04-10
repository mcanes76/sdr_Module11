function tx_symbols = bpsk_modulate_bits(bit_vector)

tx_symbols = 2*bit_vector(:).' - 1;

end
