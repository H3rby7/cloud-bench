function [output] = get_involved_ms_with_ts(traces)
    % Find all involved MS from trace.json strings
    
    trace_count = height(traces);
    nested_results = cell(trace_count,1);
    
    % parfor is possible
    for i=1:trace_count
        entry = traces(i, :);

        % Parse involved microservices from JSON
        involved_ms = regexp(entry.as_json, "MS_\d+", "match");
        involved_ms = involved_ms{:}';
        involved_ms_count = height(involved_ms);

        % Create timestamp cells
        timestamp = zeros(involved_ms_count, 1) + entry.timestamp;

        % Combine found MS with the timestamp
        nested_results(i) = {[table(involved_ms) table(timestamp)]};
    end
    
    % Combine all sub-results
    output = vertcat(nested_results{:});

end
