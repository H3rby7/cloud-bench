function service_graph_mapper(inputKVStore, ~, intermKVStore)
    % Create a directed graph from the trace entries
    % inputKVStore as created by service mapping (a KEY-VALUE store)
    % inputKVStore
        % Key = service_id
        % Value = trace entries of the service_id
    % intermKVStore
        % Key = service_id
        % Value = cell array of {digraph, nodecount, maxDepth}

    for i=1:height(inputKVStore)
        % Get all trace entries
        traces = inputKVStore.Value{i};
        service_id = inputKVStore.Key{i};
    
        % Create directed graph
        % using the trace upstream and downstream combinations to describe its edges
        graph = digraph(traces.upstream_ms', traces.downstream_ms');
    
        % Sanity Check
        ms_from_trace = unique([traces.upstream_ms ; traces.downstream_ms]);
        ms_count_graph = graph.numnodes;
        if (length(ms_from_trace) ~= ms_count_graph)
            fprintf('Warning: MS count for Service %s -> count of MS in service graph and count of MS from trace differ!\n', service_id);
            % nodenames = graph{i,3}.Nodes.Name
            % ms_from_trace
        end
    
        ms_max_depth = max(distances(graph, "USER"));
        add(intermKVStore, service_id, {graph, ms_count_graph, ms_max_depth});
        
    end
end
