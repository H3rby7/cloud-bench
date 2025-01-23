function trace_reducer(trace_id, intermValIter, outKVStore, empty_table)
    trace_id = string(trace_id);
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

    % Some calls seem to be recorded twice within a small ms timeframe and
    % the exact same downstreams, which cannot be a fan-out. So we filter
    % out these entries.
    [~, uniqueIdx] = unique(T(:, ["trace_id", "service", "rpc_id", "upstream_instance", "interface", "downstream_instance"]), "rows");
    T_unique = T(uniqueIdx,:);

    dg = digraph(T_unique.upstream_ms', T_unique.downstream_ms', 'omitselfloops');
    if hascycles(dg)
        % cyclic graphs cannot be mapped to json
        return
    end

    % Check if all mentioned ms are connected to the "USER" upstream
    if not(check_ms_connectivity(dg))
        return
    end

    % Possible improvement:
    % generate JSON without "USER" node
    % (as of now we remove it later-on)
    as_json = get_trace_string_json(dg);
    timestamp = min(T_unique.timestamp);
    
    % Possible improvement:
    % also store the ingress service (where the trace request will go)
    add(outKVStore, trace_id, table(timestamp, trace_id, as_json));
end


function [pass] = check_ms_connectivity(graph)
    % check if all entries of this trace are connected to each other
    pass = true;

    depths = distances(graph, "USER");
    if any(depths==inf)
        % at least one node of the graph is infinitely far away
        % -> meaning: not connected
        pass = false;
    end
end