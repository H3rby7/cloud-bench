function trace_reducer(service, intermValIter, outKVStore, empty_table)
    T = empty_table;
    
    % Append all entries we have to the table
    while hasnext(intermValIter)
        t_traces = getnext(intermValIter);
        T = [T;t_traces];
    end

    % Table has no entries, no more work to do
    if height(T) == 0
        return
    end

    add(outKVStore, service, sortrows(T,{'trace_id', 'rpc_id'},{'ascend', 'ascend'}));
end