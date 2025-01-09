function [trace_location, trace_header_lines, sampling_factor] = config()
    % Adjust the variables in this block to your needs and conditions

    % *************** Trace options ***************
    % trace_location of alibaba cluster trace microservices v2022
    trace_location = "../../traces/alibaba/2022-ms/CallGraph/input";
    % how many lines to skip
    trace_header_lines = 1;

    % *************** Sampling ***************
    % Workload reduction factor
    sampling_factor = 0.01;
    
end