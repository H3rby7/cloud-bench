function nodemetrics_reducer(key, intermValIter, outKVStore, empty_table)
    T = empty_table;
    
    % Append all entries we have to the table
    while hasnext(intermValIter)
        t_traces = getnext(intermValIter);
        T = [T;t_traces];
    end

    add(outKVStore, key, sortrows(T, "timestamp", "ascend"));
end
