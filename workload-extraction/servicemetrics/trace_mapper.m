function trace_mapper(data, ~, intermKVStore, involved_ms, resource_sampling_interval_ms)
    rows_with_involved_ms = ismember(data.downstream_ms, involved_ms);
    entries_with_involved_ms = data(rows_with_involved_ms,:);

    entries_with_involved_ms.timestamp = str2double(entries_with_involved_ms.timestamp(:));
    response_time = str2double(entries_with_involved_ms.response_time(:));

    valid_timestamp_idx = mod(entries_with_involved_ms.timestamp, resource_sampling_interval_ms) >= (resource_sampling_interval_ms - response_time);

    relevant_entries = entries_with_involved_ms(valid_timestamp_idx == 1,["timestamp", "downstream_ms", "downstream_instance"]);
    if height(relevant_entries) == 0
        return;
    end

    by_downstream_ms = findgroups(relevant_entries{:, "downstream_ms"});
    % Split table
    split = splitapply( @(varargin) varargin, relevant_entries , by_downstream_ms);
    downstream_ms_count = height(split);
    downstream_ms_sub_tables = cell(downstream_ms_count, 2);

    vars = relevant_entries.Properties.VariableNames;
    for i=1:downstream_ms_count
        t = table(split{i, :}, VariableNames=vars);
        downstream_ms_sub_tables{i,1} = t.downstream_ms{1};
        downstream_ms_sub_tables{i,2} = t;
    end
    addmulti(intermKVStore, vertcat(downstream_ms_sub_tables(:,1)), downstream_ms_sub_tables(:,2));

end
