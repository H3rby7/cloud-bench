function [output] = read_full_traces(full_traces_dir)
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
    
        % read CSV 
        input_table = readall(tabularTextDatastore(location, "Delimiter", "\t"));
    
        % append service+cluster to each entry
        service_id = strings(height(input_table),1) + svc;
        tmp_table = [input_table table(service_id)];
    
        % append to all results table
        full_traces = [full_traces; tmp_table];
    end

    output = full_traces;
end
