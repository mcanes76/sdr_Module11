function recovered_packet = hamming74_decode_packet_hard(hard_bits)

h_matrix = [1 1 0 1 1 0 0;
    1 0 1 1 0 1 0;
    0 1 1 1 0 0 1];

received_matrix = reshape(hard_bits(:), 7, []).';
corrected_matrix = received_matrix;

for idx = 1:size(received_matrix, 1)
    syndrome = mod(h_matrix * received_matrix(idx,:).', 2);

    if any(syndrome)
        for col_idx = 1:7
            if isequal(h_matrix(:,col_idx), syndrome)
                corrected_matrix(idx,col_idx) = mod(corrected_matrix(idx,col_idx) + 1, 2);
                break
            end
        end
    end
end

recovered_packet = reshape(corrected_matrix(:,1:4).', 1, []);

end
