function nodemetrics_mapper(data, ~, intermKVStore, max_time)

    entries_in_time = data.timestamp <= max_time;
    add(intermKVStore, "in_time", data(entries_in_time,:));

end
