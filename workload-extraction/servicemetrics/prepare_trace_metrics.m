function [output] = prepare_trace_metrics(entries)

    flatter = vertcat(entries{:,2});
    trace_metrics_flat = sortrows(vertcat(flatter{:,1}), "downstream_ms", "ascend");
    trace_metrics_flat.sampling_ts = (ceil(trace_metrics_flat.timestamp / 60000))*60000;

    % Group by timestamp and instance to get the request count
    summarized = groupsummary(trace_metrics_flat, ["downstream_instance", "sampling_ts"]);

    % Rename result table vars to join with metrics table later-on
    summarized.Properties.VariableNames = ["ms_instance_id", "timestamp", "requests"];

    output = summarized;

end