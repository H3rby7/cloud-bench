function [output] = export_traces_for_mubench(entries)
    % Find all involved MS from trace.json strings
    
    entry_count = height(entries);
    nested_results = cell(entry_count, 1);
    
    % parfor is possible
    for i=1:entry_count

        % get the entry's as_json
        e = entries(i,:);
        as_json = e.as_json{:};

        % decode into a struct
        s = jsondecode(as_json);

        % get the child-node count of 'USER', which tells us the count of
        % ingress services for the trace
        ingress_count = height(s.USER);
        ingress_service = cell(ingress_count, 1);

        if ingress_count == 1
            % For count == 1 get the ingress name differently, because
            % Matlab needs special treatment
            ingress_service(1) = fieldnames(s.USER);
        else
            % For count > 1 get all ingress names
            for k=1:ingress_count
                as_cell = fieldnames(s.USER{k});
                ingress_service(k) = as_cell(1);
            end
        end

        % convert ingress service names to be k8s conformous
        ingress_service = k8s_conformous(ingress_service);
        
        % split the trace into ingress parts
        % This also removes the 'USER: ...' wrapper
        split_by_ingress = split_trace(k8s_conformous(as_json), ingress_service);

        % Create timestamps cell for result table
        timestamp = zeros(ingress_count, 1) + e.timestamp;

        % Create trace_id cell for result table
        trace_id = strings(ingress_count, 1) + e.trace_id;

        % Merge cells as result table for this 'i'
        nested_results{i} = [table(timestamp) table(trace_id) split_by_ingress];

    end
    
    % Combine all nested results
    flattened = vertcat(nested_results{:});

    % Sort by timestamp and return
    output = sortrows(flattened, "timestamp", "ascend");
end

function [output] = split_trace(full_json, ingress_service)
    % full_json contains 'USER' wrappe json, which may have multiple
    % children (ingress services)
    ingress_count = height(ingress_service);

    % Prepare cell holding our traces (per ingress service)
    as_json = cell(ingress_count, 1);

    % json2process will be a mutable string
    % processed parts will be removed
    
    % rm the two brackets belonging to 'USER' node from json string
    % We want to remove the last two characters, since this function is
    % suddenly 0-indexed we work with str_len - 1
    json2process = extractBefore(full_json, strlength(full_json) -1);

    % For all ingress services, starting in the back
    for i=sort(1:ingress_count, "desc")
        % Find Start of the sub_trace, by looking for the svc name
        % and taking two additional characters -> {"
        startpos = strfind(json2process, ingress_service{i}) - 3;

        % For the trace take everything after {"ms-xyz
        as_json{i} = extractAfter(json2process, startpos);

        % Remove processed parts from json2process
        json2process = extractBefore(json2process, startpos);
    end

    % Output the ingress services with their trace
    output = table(ingress_service, as_json);
end