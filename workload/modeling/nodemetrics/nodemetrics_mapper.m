function nodemetrics_mapper(data, ~, intermKVStore, max_timestamp)
    % Filters for metrics within the timeframe
    relevant_idx = data.timestamp <= max_timestamp;
    relevant_entries = data(relevant_idx,:);
    if height(relevant_entries) == 0
        return;
    end

    groups = relevant_entries.node_id;
    
    % Find the unique groups
    [node_id,~,idx] = unique(groups, 'stable');
    
    % Group delays by idx and apply @grpstatsfun function to each group
    cpu_utilization = accumarray(idx,relevant_entries.cpu_utilization,size(node_id),@grpstatsfun);
    memory_utilization = accumarray(idx,relevant_entries.memory_utilization,size(node_id),@grpstatsfun);
    % Combine to AxB double
    combined = [vertcat(cpu_utilization{:}) vertcat(memory_utilization{:})];
    % Convert AxB double to a cell array with 
    % A rows of size 1 containing B doubles
    as_cell = mat2cell(combined, ones(height(combined), 1), width(combined));
    addmulti(intermKVStore,node_id,as_cell);

end

function out = grpstatsfun(x)
    n = length(x); % count
    m = sum(x)/n; % mean
    v = sum((x-m).^2)/n; % variance
    s = sum((x-m).^3)/n; % skewness without normalization
    k = sum((x-m).^4)/n; % kurtosis without normalization
    out = {[n, m, v, s, k]};
end