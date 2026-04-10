clear
close all
clc

capture_files = {'OTA_Capture1.mat', 'OTA_Capture2.mat', ...
    'OTA_Capture3.mat', 'OTA_Capture4.mat'};

capture_folder = fullfile('..', 'OTA_Captures');
noise_estimates = zeros(1, length(capture_files));
noise_truth = zeros(1, length(capture_files));
relative_error = zeros(1, length(capture_files));
k_est_vec = zeros(1, length(capture_files));
num_observations_vec = zeros(1, length(capture_files));
observation_length_vec = zeros(1, length(capture_files));

for idx = 1:length(capture_files)
    loaded_data = load(fullfile(capture_folder, capture_files{idx}));
    loaded_fields = fieldnames(loaded_data);

    captured_data = [];
    noise_power = [];

    for field_idx = 1:length(loaded_fields)
        field_name = loaded_fields{field_idx};
        field_value = loaded_data.(field_name);
        field_name_lower = lower(field_name);

        if isempty(captured_data) && isnumeric(field_value) && ~isscalar(field_value) ...
                && contains(field_name_lower, 'capture')
            captured_data = field_value;
        end

        if isempty(captured_data) && isnumeric(field_value) && ~isscalar(field_value) ...
                && contains(field_name_lower, 'data')
            captured_data = field_value;
        end

        if isempty(noise_power) && isnumeric(field_value) && isscalar(field_value) ...
                && contains(field_name_lower, 'noise')
            noise_power = field_value;
        end
    end

    if isempty(captured_data)
        for field_idx = 1:length(loaded_fields)
            field_value = loaded_data.(loaded_fields{field_idx});
            if isnumeric(field_value) && ~isscalar(field_value)
                captured_data = field_value;
                break
            end
        end
    end

    if isempty(noise_power)
        for field_idx = 1:length(loaded_fields)
            field_value = loaded_data.(loaded_fields{field_idx});
            if isnumeric(field_value) && isscalar(field_value)
                noise_power = field_value;
                break
            end
        end
    end

    [noise_estimates(idx), estimate_info] = EstimateNoise(captured_data);
    noise_truth(idx) = noise_power;
    relative_error(idx) = abs(noise_estimates(idx) - noise_truth(idx)) / noise_truth(idx);
    k_est_vec(idx) = estimate_info.kMin;
    num_observations_vec(idx) = estimate_info.num_observations;
    observation_length_vec(idx) = estimate_info.observation_length;

    fprintf('%s\n', capture_files{idx})
    fprintf('estimate: %.6f\n', noise_estimates(idx))
    fprintf('error: %.6f\n\n', relative_error(idx))
end

save('problem_2_3_results.mat', 'capture_files', 'noise_estimates', 'noise_truth', ...
    'relative_error', 'k_est_vec', 'num_observations_vec', 'observation_length_vec')
