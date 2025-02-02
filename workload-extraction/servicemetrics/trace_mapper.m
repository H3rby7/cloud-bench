function trace_mapper(data, ~, intermKVStore, involved_ms, resource_sampling_interval_ms, tolerance_ms)
    min_timestamp_after_modulo = resource_sampling_interval_ms - tolerance_ms;

    valid_downstream_idx = ismember(data.downstream_ms, involved_ms);
    valid_timestamp_idx = mod(data.timestamp, resource_sampling_interval_ms) > min_timestamp_after_modulo;
    good_rows = valid_downstream_idx & valid_timestamp_idx;
    relevant_entries = data(good_rows,:);
    if height(relevant_entries) == 0
        return;
    end

    by_downstream_ms = findgroups(relevant_entries{:, "downstream_ms"});
    % Split table
    split = splitapply( @(varargin) varargin, relevant_entries , by_downstream_ms);
    downstream_ms_count = height(split);
    downstream_ms_sub_tables = cell(downstream_ms_count, 2);

    vars = data.Properties.VariableNames;
    for i=1:downstream_ms_count
        t = table(split{i, :}, VariableNames=vars);
        downstream_ms_sub_tables{i,1} = t.downstream_ms{1};
        downstream_ms_sub_tables{i,2} = t;
    end
    addmulti(intermKVStore, vertcat(downstream_ms_sub_tables(:,1)), downstream_ms_sub_tables(:,2));

end
