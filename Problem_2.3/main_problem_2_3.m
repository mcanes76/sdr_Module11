clear
close all
clc

capture_files = {'OTA_Capture1.mat', 'OTA_Capture2.mat', ...
    'OTA_Capture3.mat', 'OTA_Capture4.mat'};

capture_folder = fullfile('..', 'OTA_Captures');
estimates = zeros(1, length(capture_files));
true_noise = zeros(1, length(capture_files));
relative_error = zeros(1, length(capture_files));
estimated_k = zeros(1, length(capture_files));
num_observations_vec = zeros(1, length(capture_files));
observation_length_vec = zeros(1, length(capture_files));
sorted_eig_vectors = cell(1, length(capture_files));
mdl_values = cell(1, length(capture_files));

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

    [estimates(idx), estimate_info] = EstimateNoise(captured_data);
    true_noise(idx) = noise_power;
    relative_error(idx) = abs(estimates(idx) - true_noise(idx)) / true_noise(idx);
    estimated_k(idx) = estimate_info.kMin;
    num_observations_vec(idx) = estimate_info.num_observations;
    observation_length_vec(idx) = estimate_info.observation_length;
    sorted_eig_vectors{idx} = estimate_info.sorted_eig_vector;
    mdl_values{idx} = estimate_info.kVal;

    fprintf('----------------------------------\n')
    fprintf('File: %s\n', capture_files{idx})
    fprintf('Estimated Noise Power: %.6f\n', estimates(idx))
    fprintf('True Noise Power: %.6f\n', true_noise(idx))
    fprintf('Relative Error: %.6f\n', relative_error(idx))
    fprintf('Estimated k: %d\n', estimated_k(idx))

    if relative_error(idx) >= 0.05
        fprintf('Requirement failed for this capture.\n')
        fprintf('Eigenvalues:\n')
        disp(sorted_eig_vectors{idx}.')
    end

    fprintf('----------------------------------\n\n')
end

figure
tiledlayout(2,2)
for idx = 1:length(capture_files)
    nexttile
    stem(sorted_eig_vectors{idx}, 'filled')
    title(capture_files{idx}, 'Interpreter', 'none')
    xlabel('Index')
    ylabel('Eigenvalue')
    grid on
end
exportgraphics(gcf, 'problem_2_3_eigenvalues.png', 'Resolution', 150)

figure
tiledlayout(2,2)
for idx = 1:length(capture_files)
    nexttile
    plot(0:length(mdl_values{idx})-1, mdl_values{idx}, '-o')
    title(capture_files{idx}, 'Interpreter', 'none')
    xlabel('k')
    ylabel('MDL(k)')
    grid on
end
exportgraphics(gcf, 'problem_2_3_mdl.png', 'Resolution', 150)

save('problem_2_3_results.mat', 'capture_files', 'estimates', 'true_noise', ...
    'relative_error', 'estimated_k', 'num_observations_vec', ...
    'observation_length_vec', 'sorted_eig_vectors', 'mdl_values')
