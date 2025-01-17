function [output] = ms_min_timestamps(traces)
    % For all involved MS find out when they are first needed.
    
    trace_count = height(traces);
    nested_results = cell(trace_count,1);
    
    parfor i=1:trace_count
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
    in_flat = vertcat(nested_results{:});

    % Find minimum timestamp for every MS and sort
    output = sortrows(groupsummary(in_flat, "involved_ms", "min", "timestamp"), "min_timestamp", "ascend");

end
