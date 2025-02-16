function service_reducer(service, intermValIter, outKVStore, sampling_factors)
    T = table();
    
    % Append all entries we have to the table
    while hasnext(intermValIter)
        t_traces = getnext(intermValIter);
        T = [T;t_traces];
    end

    trace_count = height(T);
    % Table has no entries, no more work to do
    if trace_count == 0
        return
    end
    
    % We will take every n-th trace
    n = 1 / (sampling_factors.service_sampling_factor(strcmp(sampling_factors.service_id, service)));
    % Create a range from every n-th element up to trace_count
    sample_idx = round(1:n:trace_count);

    % Sort input by timestamp
    timesorted = sortrows(T,'timestamp','ascend');

    % Extract the samle
    sample = timesorted(sample_idx,:);
    sample_size = height(sample);

    % Create call_graph jsons for every sample
    as_json = cell(sample_size, 1);
    for i=1:sample_size
        as_json{i} = get_trace_string_json(sample.graph{i});
    end

    % Concat useful info into a table for this service
    output = [sample(:,["timestamp", "service", "trace_id"]), table(as_json)];
    add(outKVStore, service, output);
end
