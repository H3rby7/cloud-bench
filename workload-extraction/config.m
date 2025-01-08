function [trace_location, trace_header_lines, output_dir_sequential, output_dir_parallel, output_dir_root, similarity_threshold, sampling_factor] = config()
    % Adjust the variables in this block to your needs and conditions

    % *************** Trace options ***************
    % trace_location of alibaba cluster trace microservices v2022
    trace_location = "../traces/alibaba/2022-ms/CallGraph/CallGraph_0.csv";
    % how many lines to skip
    trace_header_lines = 1;


    % *************** Directories for output ***************
    % Root DIR for output
    output_dir_root = "../traces-mbench";
    % DIR within root DIR to hold sequential output
    output_dir_sequential = output_dir_root+"/sequential";
    % DIR within root DIR to hold parallel output
    output_dir_parallel = output_dir_root+"/parallel";

    % *************** Sampling ***************
    % Service graph similarity threshold
    similarity_threshold = 0.8;

    % Workload reduction factor
    sampling_factor = 0.01;
    
end