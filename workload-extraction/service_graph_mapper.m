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

        % RM duplicate edges, as we do not use this information
        simple_graph = simplify(graph);
        if graph.hascycles
            fprintf('Warning: Service %s -> graph has cycles, skipping!\n', service_id);
            continue
        end

        % Sanity Check
        ms_from_trace = unique([traces.upstream_ms ; traces.downstream_ms]);
        graph_node_count = simple_graph.numnodes;
        if (length(ms_from_trace) ~= graph_node_count)
            fprintf('Warning: Node count for Service %s -> count of nodes in service graph and count of node from trace differ!\n', service_id);
            % nodenames = graph{i,3}.Nodes.Name
            % ms_from_trace
        end
    
        % Subtract the "USER" from the node_count to get the ms_count
        ms_count = graph_node_count - 1;
        ms_max_depth = max(distances(simple_graph, "USER"));
        trace_count = height(unique(traces.trace_id));
        possible_node_names = graph_nodes_as_rpc_ids(simple_graph,4);
        add(intermKVStore, service_id, {simple_graph, possible_node_names, ms_count, ms_max_depth, trace_count});
        
    end
end
