function service_graph_reducer(service, intermValIter, outKVStore)
    entry = getnext(intermValIter);
    if hasnext(intermValIter)
        fprintf("WARN: %s has more than one entry?!", service);
    end

    add(outKVStore, service, entry);
end
