function [trace_location, trace_header_lines] = trace_config()
    % Adjust the variables in this block to your needs and conditions

    % *************** Trace options ***************
    % trace_location of alibaba cluster trace microservices v2022
    % With the first 20 files to cover a one-hour interval
    trace_location = "../../traces/alibaba/2022-ms/CallGraph/input";
    % trace_location = "../../traces/alibaba/2022-ms/CallGraph/CallGraph_test.csv";
    % how many lines to skip
    trace_header_lines = 1;

end