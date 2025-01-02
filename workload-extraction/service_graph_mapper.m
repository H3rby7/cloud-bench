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
        graph_node_count = graph.numnodes;
        if (length(ms_from_trace) ~= graph_node_count)
            fprintf('Warning: Node count for Service %s -> count of nodes in service graph and count of node from trace differ!\n', service_id);
            % nodenames = graph{i,3}.Nodes.Name
            % ms_from_trace
        end
    
        % Subtract the "USER" from the node_count to get the ms_count
        ms_count = graph_node_count - 1;
        ms_max_depth = max(distances(graph, "USER"));
        trace_count = height(unique(traces.trace_id));
        add(intermKVStore, service_id, {graph, ms_count, ms_max_depth, trace_count});
        
    end
end
