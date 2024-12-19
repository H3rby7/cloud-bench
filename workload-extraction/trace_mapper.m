function trace_mapper(data, ~, intermKVStore, col_idx_service)

    by_service = findgroups(data{:, col_idx_service});
    % Split table
    split = splitapply( @(varargin) varargin, data , by_service);
    service_count = height(split);
    service_tables = cell(service_count, 2);

    vars = data.Properties.VariableNames;
    for i=1:service_count
        t = table(split{i, :}, VariableNames=vars);
        service_tables{i,1} = t.service{1};
        unavailable_interface_idx = strcmp(t.interface, "UNAVAILABLE") > 0;
        unavailable_upstream_instance_idx = strcmp(t.upstream_instance, "UNAVAILABLE") > 0;
        unavailable_downstream_instance_idx = strcmp(t.downstream_instance, "UNAVAILABLE") > 0;
        bad_rows = unavailable_interface_idx | unavailable_upstream_instance_idx | unavailable_downstream_instance_idx;
        % It may be useful to check for the trace_id's related to the bad
        % rows and drop all entries for the given trace_ids
        % This requires further investigation on whether the resulting gaps
        % can be filled by other trace data or remain open.
        service_tables{i,2} = t(~bad_rows,:);
    end
    addmulti(intermKVStore, vertcat(service_tables(:,1)), service_tables(:,2));

end
