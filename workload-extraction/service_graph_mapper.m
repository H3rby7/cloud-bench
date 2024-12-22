function service_graph_mapper(data, ~, intermKVStore)
    % data as created by service mapping (a KEY-VALUE store)
    % Key = service_id
    % Value = trace entries of the service_id

    for i=1:height(data)
        % Get all trace entries
        traces = data.Value{i};
        service_id = data.Key{i};
    
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
    
        add(intermKVStore, service_id, graph);
        
    end
end
