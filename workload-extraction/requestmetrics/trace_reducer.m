function trace_reducer(ms_name, intermValIter, outKVStore)
    ms_name = string(ms_name);
    T = table();
    
    % Append all entries we have to the table
    while hasnext(intermValIter)
        t_traces = getnext(intermValIter);
        T = [T;t_traces];
    end

    trace_count = height(T);

    if trace_count < 2
        warning("MS '%s' has less than two entries. Consider using more input data.", ms_name)
    end

    add(outKVStore, ms_name, T);
end
