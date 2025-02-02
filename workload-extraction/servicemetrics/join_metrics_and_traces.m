function [output] = join_metrics_and_traces(metrics, traces)
    
    % Sadly we do not have metric information on all microservices involved
    % in the trace data, so we need to find the shared ms_instance_ids
    metrics_ms_instance_ids = sort(unique(metrics.ms_instance_id));
    traces_ms_instance_ids = sort(unique(traces.ms_instance_id));
    shared_ms_instance_ids = metrics_ms_instance_ids(ismember(metrics_ms_instance_ids, traces_ms_instance_ids));

    % Reduce datasize by using only shared ms_instance_ids
    shared_metrics = metrics(ismember(metrics.ms_instance_id, shared_ms_instance_ids),:);
    shared_traces = traces(ismember(traces.ms_instance_id, shared_ms_instance_ids),:);

    shared_metrics.requests = zeros(height(shared_metrics),1);

    % Matlab nativ JOIN does not work as we do not have trace entries for every
    % timestamp, so we do it by hand
    for i=1:height(shared_metrics)
        ms_instance_id = shared_metrics.ms_instance_id{i};
        timestamp = shared_metrics.timestamp(i);
        requests = sum(shared_traces.requests(...
            shared_traces.ms_instance_id == ms_instance_id &...
            shared_traces.timestamp == timestamp...
        ));
        shared_metrics.requests(i) = requests;
    end

    output = sortrows(shared_metrics, ["ms_instance_id", "requests"], ["ascend", "descend"]);

end