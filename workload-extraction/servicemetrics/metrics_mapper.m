function metrics_mapper(data, ~, intermKVStore, max_timestamp, involved_ms)
        
    relevant_idx = ismember(data.ms_name, involved_ms) & data.timestamp <= max_timestamp;
    relevant_entries = data(relevant_idx,:);
    if height(relevant_entries) == 0
        return;
    end

    entry_count = height(relevant_entries);
    results = cell(entry_count, 2);

    for i=1:entry_count
        ms_name = string(relevant_entries{i, "ms_name"});
        ms_instance_id = string(relevant_entries{i, "ms_instance_id"});
        node_id = string(relevant_entries{i, "node_id"});
        timestamp = relevant_entries{i, "timestamp"};

        metric = "cpu";
        value = relevant_entries{i, "cpu_utilization"};
        table_mem = table(ms_name, metric, ms_instance_id, node_id, timestamp, value);
        metric = "memory";
        value = relevant_entries{i, "memory_utilization"};
        table_cpu = table(ms_name, metric, ms_instance_id, node_id, timestamp, value);
        results{i,1} = ms_name;
        results{i,2} = [table_mem; table_cpu];
    end

    ms_names = vertcat(results{:,1});
    unique_names = unique(ms_names);
    ms_count = height(unique_names);
    output = cell(ms_count, 1);
    
    for i=1:ms_count
        ms_name = unique_names{i};
        
        results_for_ms_idx = strcmp(ms_names, ms_name);
        results_for_ms = vertcat(results{results_for_ms_idx,2});

        output{i} = results_for_ms;
    end

    addmulti(intermKVStore, unique_names, output);

end
