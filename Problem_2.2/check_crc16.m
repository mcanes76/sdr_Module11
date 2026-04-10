function [crc_pass, recovered_payload] = check_crc16(recovered_packet)

generator = [1 0 0 0 1 0 0 0 0 0 0 1 0 0 0 0 1];
crc_length = length(generator) - 1;

recovered_packet = recovered_packet(:).';
recovered_payload = recovered_packet(1:end-crc_length);
work_bits = recovered_packet;

for idx = 1:length(recovered_payload)
    if work_bits(idx) == 1
        work_bits(idx:idx+crc_length) = mod(work_bits(idx:idx+crc_length) + generator, 2);
    end
end

crc_pass = all(work_bits(end-crc_length+1:end) == 0);

end
