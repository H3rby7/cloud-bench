function [trace_location, trace_header_lines, sampling_factor] = config()
    % Adjust the variables in this block to your needs and conditions

    % *************** Trace options ***************
    % trace_location of alibaba cluster trace microservices v2022
    trace_location = "../../traces/alibaba/2022-ms/CallGraph/input";
    % how many lines to skip
    trace_header_lines = 1;

    % *************** Sampling ***************
    % Workload reduction factor
    % Original Workload is for ~40K baremetal nodes
    raw_trace_node_count = 40000;
    % We want to aim at ~10 nodes
    target_node_count = 10;
    % Service sampling has already reduced to this factor
    sampled_service_factor = 0.01;
    % Sampling factor for traces (~0.025)
    sampling_factor = (target_node_count / raw_trace_node_count) / sampled_service_factor;
    
end