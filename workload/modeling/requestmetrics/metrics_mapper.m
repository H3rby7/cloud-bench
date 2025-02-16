function metrics_mapper(data, ~, intermKVStore, max_timestamp, involved_ms)
    % Only filters for the involved MS and within the timeframe
    relevant_idx = ismember(data.ms_name, involved_ms) & data.timestamp <= max_timestamp;
    relevant_entries = data(relevant_idx,:);
    if height(relevant_entries) == 0
        return;
    end

    add(intermKVStore, "entries", relevant_entries);

end
