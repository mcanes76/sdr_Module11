function packet_bits = append_crc16(payload_bits)

generator = [1 0 0 0 1 0 0 0 0 0 0 1 0 0 0 0 1];
crc_length = length(generator) - 1;

work_bits = [payload_bits(:).' zeros(1, crc_length)];

for idx = 1:length(payload_bits)
    if work_bits(idx) == 1
        work_bits(idx:idx+crc_length) = mod(work_bits(idx:idx+crc_length) + generator, 2);
    end
end

crc_bits = work_bits(end-crc_length+1:end);
packet_bits = [payload_bits(:).' crc_bits];

end
