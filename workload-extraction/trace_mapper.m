function trace_mapper(data, ~, intermKVStore, col_idx_trace_id)

    by_trace_id = findgroups(data{:, col_idx_trace_id});
    % Split table
    split = splitapply( @(varargin) varargin, data , by_trace_id);
    trace_id_count = height(split);
    trace_sub_tables = cell(trace_id_count, 2);

    vars = data.Properties.VariableNames;
    for i=1:trace_id_count
        t = table(split{i, :}, VariableNames=vars);
        trace_sub_tables{i,1} = t.trace_id{1};
        unavailable_interface_idx = ismember(t.interface, ["UNAVAILABLE", "UNKNOWN"]);
        unavailable_upstream_idx = ismember(t.upstream_ms, ["UNAVAILABLE", "UNKNOWN"]);
        unavailable_downstream_idx = ismember(t.downstream_ms, ["UNAVAILABLE", "UNKNOWN"]);
        bad_rows = unavailable_interface_idx | unavailable_upstream_idx | unavailable_downstream_idx;
        % It may be useful to check for the trace_id's related to the bad
        % rows and drop all entries for the given trace_ids
        % This requires further investigation on whether the resulting gaps
        % can be filled by other trace data or remain open.
        trace_sub_tables{i,2} = t(~bad_rows,:);
    end
    addmulti(intermKVStore, vertcat(trace_sub_tables(:,1)), trace_sub_tables(:,2));

end
