function [falsealarmvec_endet_th, posdetvec_endet_th] = ...
    compute_theoretical_roc(threshold_range, measurement_length, sigma_n, signal_amplitude)

falsealarmvec_endet_th = zeros(size(threshold_range));
posdetvec_endet_th = zeros(size(threshold_range));
signal_term = abs(signal_amplitude)*sqrt(measurement_length)/sigma_n;

for idx = 1:length(threshold_range)
    eta = threshold_range(idx);

    falsealarmvec_endet_th(idx) = ...
        gammainc(eta/(2*sigma_n^2), measurement_length, 'upper');

    posdetvec_endet_th(idx) = ...
        marcumq(signal_term, ...
        sqrt(eta)/sigma_n, measurement_length);
end

end
