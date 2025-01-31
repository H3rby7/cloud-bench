function metrics_reducer(ms_name, intermValIter, outKVStore)
    T = table();

    % Append all entries we have to the table
    while hasnext(intermValIter)
        t_metrics = getnext(intermValIter);
        T = [T;t_metrics];
    end

    extremes = groupsummary(T, ["ms_name", "metric"], ["min", "max"], "value");
    cpu_min_val = extremes.min_value(extremes.metric == "cpu");
    cpu_max_val = extremes.max_value(extremes.metric == "cpu");
    memory_min_val = extremes.min_value(extremes.metric == "memory");
    memory_max_val = extremes.max_value(extremes.metric == "memory");

    cpu_min = T(T.metric == "cpu" & T.value == cpu_min_val, :);
    cpu_max = T(T.metric == "cpu" & T.value == cpu_max_val, :);
    memory_min = T(T.metric == "memory" & T.value == memory_min_val, :);
    memory_max = T(T.metric == "memory" & T.value == memory_max_val, :);
    
    joined = vertcat(cpu_min, cpu_max, memory_min, memory_max);

    % Errors when min or max has the same value twice!
    type = ["min"; "max"; "min"; "max"];

    add(outKVStore, ms_name, [joined table(type)]);
end
