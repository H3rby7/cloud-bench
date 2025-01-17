function [output] = read_full_traces(service_samples, take_all)
    [~, ~, full_traces_dir, sampling_factor] = config();
    % Result table
    full_traces = table();
    
    % Get file info
    files = struct2table(dir(full_traces_dir));
    % Get list of files only (no DIRs)
    file_name = files.name(files.isdir ~= 1);
    
    for i=1:height(file_name)
        % FOR every file
        f = file_name{i};
        location = full_traces_dir + "/" + f;
    
        % extract service from filename
        svc = regexp(f, "S_[0-9]+", "match");
    
        % get cluster with the service name
        clust = service_samples.cluster(service_samples.service_id == svc);
    
        % read CSV 
        input_table = readall(tabularTextDatastore(location, "RowDelimiter", "\n", "Delimiter", "\t"));
        if ~take_all
            % get trace factor for this service
            trace_factor = service_samples.trace_factor(service_samples.service_id == svc);
            factor = sampling_factor * trace_factor;

            % get sample indices
            idx = sample_indices(height(input_table), factor);

            % input table as sampled subset
            input_table = input_table(idx, :);
        end
    
        % append service+cluster to each entry
        service_id = strings(height(input_table),1) + svc;
        cluster = zeros(height(input_table), 1) + clust;
        tmp_table = [input_table table(service_id) table(cluster)];
    
        % append to all results table
        full_traces = [full_traces; tmp_table];
    end

    output = full_traces;
end
