function service_mapper(data, ~, intermKVStore)
    % data as created by trace mapping (a KEY-VALUE store)
    % Key = trace_id
    % Value = trace entries of the trace_id

    % Get all traces
    traces = vertcat(data.Value{:});

    % group traces by service
    by_service = findgroups(traces{:, "service"});

    split = splitapply( @(varargin) varargin, traces , by_service);
    service_count = height(split);

    % prepare result cells
    service_tables = cell(service_count, 2);

    vars = traces.Properties.VariableNames;
    for i=1:service_count
        % create sub-table for service and add to results
        t = table(split{i, :}, VariableNames=vars);
        service_tables{i,1} = t.service{1};
        service_tables{i,2} = t;
    end
    addmulti(intermKVStore, vertcat(service_tables(:,1)), service_tables(:,2));

end
