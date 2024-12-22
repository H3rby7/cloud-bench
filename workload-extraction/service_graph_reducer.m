function service_graph_reducer(service, intermValIter, outKVStore)
    graph = getnext(intermValIter);
    if hasnext(intermValIter)
        fprintf("WARN: %s has more than one entry?!", service);
    end

    add(outKVStore, service, graph);
end
