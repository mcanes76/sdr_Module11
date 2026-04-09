num_samples_per_observation = 64;
num_observations = 256;
num_samples_in_simulation = num_samples_per_observation*num_observations;

samples_per_symbol = 8;
num_symbols = num_samples_in_simulation/samples_per_symbol;
test_signal = exp(1.0i*2*pi*0.125*(0:(num_samples_in_simulation-1)));
test_signal=test_signal(:);
symbol_vector = randi([0 1], num_symbols, 1)*2-1;
modulation_vector = repelem(symbol_vector,samples_per_symbol);
modulation_vector=modulation_vector(:);
modulated_test_signal = test_signal.*modulation_vector;

noise_vec = randn(num_samples_in_simulation,1);
noise_vec = noise_vec + 1.0i*randn(num_samples_in_simulation,1);
noise_vec = noise_vec - mean(noise_vec);
noise_vec = noise_vec/sqrt(var(noise_vec));
noise_vec = noise_vec/sqrt(10);
noisy_modulated_test_signal = modulated_test_signal + noise_vec;


% Observation matrix of the noise
% test_signal = exp(1.0i*2*pi*0.125*[0:(num_samples_in_simulation-1)]);
% test_signal=test_signal(:);


% reshape vector 
signal_matrix = reshape(noisy_modulated_test_signal, num_samples_per_observation,...
num_observations);
sigma_matrix = (signal_matrix*signal_matrix')/(num_observations-1);

% Take the eigenvalues
eig_vector = eig(sigma_matrix);
sorted_eig_vector = sort(eig_vector, 'descend');
figure(7)
stem(sorted_eig_vector)

% Estimate of noise value
[kVal, kMin] = calcKMin(sorted_eig_vector, num_observations, num_samples_per_observation);
noise_eigenvalues = sorted_eig_vector(kMin+1:num_samples_per_observation);
estimated_noise_power = mean(noise_eigenvalues);
actual_noise_power = var(noise_vec);
error_val = abs(actual_noise_power-estimated_noise_power)/actual_noise_power