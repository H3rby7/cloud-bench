function metrics_mapper(data, ~, intermKVStore, max_timestamp)
    % Filters for metrics within the timeframe
    relevant_idx = data.timestamp <= max_timestamp;
    relevant_entries = data(relevant_idx,:);
    if height(relevant_entries) == 0
        return;
    end

    add(intermKVStore, "entries", relevant_entries);

end
