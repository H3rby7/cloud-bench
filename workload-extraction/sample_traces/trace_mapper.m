function trace_mapper(data, ~, intermKVStore, col_idx_trace_id, service_samples)

    valid_service_ids = service_samples.service_id;
    entry_with_valid_service_idx = ismember(data.service, valid_service_ids);
    entry_with_valid_service = data(entry_with_valid_service_idx,:);

    by_service = findgroups(entry_with_valid_service{:, "service"});
    % Split table
    split_by_service = splitapply( @(varargin) varargin, entry_with_valid_service , by_service);
    service_id_count = height(split_by_service);
    service_sub_tables = cell(service_id_count, 1);

    vars = data.Properties.VariableNames;
    for i=1:service_id_count
        t = table(split_by_service{i, :}, VariableNames=vars);
        svc = t.service{1};
        unavailable_interface_idx = ismember(t.interface, ["UNAVAILABLE", "UNKNOWN"]);
        valid_involved_ms = service_samples{strcmp(service_samples.service_id, svc),"involved_ms"}{1};
        valid_upstream_idx = ismember(t.upstream_ms, valid_involved_ms);
        valid_downstream_idx = ismember(t.downstream_ms, valid_involved_ms);
        good_rows = ~unavailable_interface_idx & valid_upstream_idx & valid_downstream_idx;
        % It may be useful to check for the trace_id's related to the bad
        % rows and drop all entries for the given trace_ids
        % This requires further investigation on whether the resulting gaps
        % can be filled by other trace data or remain open.
        service_sub_tables{i} = t(good_rows,:);
    end

    relevant_entries = vertcat(service_sub_tables{:,:});
    
    by_trace_id = findgroups(relevant_entries{:, col_idx_trace_id});
    % Split table
    split = splitapply( @(varargin) varargin, relevant_entries , by_trace_id);
    trace_id_count = height(split);
    trace_sub_tables = cell(trace_id_count, 2);

    vars = data.Properties.VariableNames;
    for i=1:trace_id_count
        t = table(split{i, :}, VariableNames=vars);
        trace_sub_tables{i,1} = t.trace_id{1};
        trace_sub_tables{i,2} = t;
    end
    addmulti(intermKVStore, vertcat(trace_sub_tables(:,1)), trace_sub_tables(:,2));

end
