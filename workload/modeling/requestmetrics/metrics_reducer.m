function metrics_reducer(key, intermValIter, outKVStore)
    T = table();

    % Append all entries we have to the table
    while hasnext(intermValIter)
        t_metrics = getnext(intermValIter);
        T = [T;t_metrics];
    end

    add(outKVStore, key, T);
end
