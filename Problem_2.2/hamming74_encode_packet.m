function coded_packet = hamming74_encode_packet(packet_bits)

packet_matrix = reshape(packet_bits(:), 4, []).';
d1 = packet_matrix(:,1);
d2 = packet_matrix(:,2);
d3 = packet_matrix(:,3);
d4 = packet_matrix(:,4);

p1 = mod(d1 + d2 + d4, 2);
p2 = mod(d1 + d3 + d4, 2);
p3 = mod(d2 + d3 + d4, 2);

coded_matrix = [d1 d2 d3 d4 p1 p2 p3];
coded_packet = reshape(coded_matrix.', 1, []);

end
