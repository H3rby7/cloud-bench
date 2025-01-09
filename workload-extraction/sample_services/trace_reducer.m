function trace_reducer(trace_id, intermValIter, outKVStore, empty_table)
    T = empty_table;
    
    % Append all entries we have to the table
    while hasnext(intermValIter)
        t_traces = getnext(intermValIter);
        T = [T;t_traces];
    end

    trace_count = height(T);

    if trace_count == 0
        % trace has no entries -> no more work to do
        return
    end

    % Check for sane rpc_id structure in the traces
    if not(are_parents_present(T))
        return
    end

    % Check if all mentioned ms are connected to the "USER" upstream
    if not(check_ms_connectivity(T))
        return
    end

    % Some calls seem to be recorded twice within a small ms timeframe and
    % the exact same downstreams, which cannot be a fan-out. So we filter
    % out these entries.
    [~, uniqueIdx] = unique(T(:, ["trace_id", "service", "rpc_id", "upstream_instance", "interface", "downstream_instance"]), "rows");

    add(outKVStore, trace_id, sortrows(T(uniqueIdx,:),'rpc_id','ascend'));
end


function [pass] = check_ms_connectivity(trace)
    % check if all entries of this trace are connected to each other
    pass = true;

    G = digraph(trace.upstream_ms', trace.downstream_ms', 'omitselfloops');
    depths = distances(G, "USER");
    if any(depths==inf)
        % at least one node of the graph is infinitely far away
        % -> meaning: not connected
        pass = false;
    end
end