measurement_length = 1;
number_of_measurements = 16384;

num_samples_in_simulation = measurement_length*number_of_measurements;
noisesigma = 10; % the standard deviation of one axis of noise
noise_signal = randn(measurement_length*number_of_measurements,1) + ...
1.0i*randn(measurement_length*number_of_measurements,1);
noise_signal = noise_signal - mean(noise_signal);
noise_signal = noise_signal/sqrt(var(noise_signal))*noisesigma*sqrt(2);
received_signal = noise_signal;

measurement_matrix = ...
reshape(received_signal, measurement_length, number_of_measurements);

decision_metrics = sum(abs(measurement_matrix).^2, 1);

threshold_value = 2.5*measurement_length;
detection_vector = decision_metrics > threshold_value;
probability_of_detection = detection_vector/length(detection_vector);

probability_of_false_alarm = sum(detection_vector)/length(detection_vector)
theoretical_probability_of_false_alarm = ...
gammainc( threshold_value/2/noisesigma^2, measurement_length, 'upper')

figure
histogram(decision_metrics)