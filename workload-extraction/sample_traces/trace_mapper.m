function trace_mapper(data, ~, intermKVStore, col_idx_trace_id, service, involved_ms)

    entry_with_valid_service_idx = strcmp(data.service, service);
    if sum(entry_with_valid_service_idx) == 0
        % no entries in this batch!
        return;
    end
    entry_with_valid_service = data(entry_with_valid_service_idx,:);
        
    unavailable_interface_idx = ismember(entry_with_valid_service.interface, ["UNAVAILABLE", "UNKNOWN"]);
    valid_upstream_idx = ismember(entry_with_valid_service.upstream_ms, involved_ms);
    valid_downstream_idx = ismember(entry_with_valid_service.downstream_ms, involved_ms);
    good_rows = ~unavailable_interface_idx & valid_upstream_idx & valid_downstream_idx;
    % It may be useful to check for the trace_id's related to the bad
    % rows and drop all entries for the given trace_ids
    % This requires further investigation on whether the resulting gaps
    % can be filled by other trace data or remain open.

    relevant_entries = entry_with_valid_service(good_rows,:);
    if height(relevant_entries) == 0
        return;
    end
    
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
