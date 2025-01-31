function [service_samples_export_file, trace_location, trace_header_lines, full_traces_dir, sampling_factor, service_graph_output_file, trace_csv_output_file, deployment_ts_output_file] = config()
    % Adjust the variables in this block to your needs and conditions

    % *************** Service Samples ***************
    % Result from clustering and sampling the services
    service_samples_export_file = "../sampled_services_export.mat";

    % *************** Trace options ***************
    % trace_location of alibaba cluster trace microservices v2022
    % With the first 20 files to cover a one-hour interval
    trace_location = "../../traces/alibaba/2022-ms/CallGraph/input";
    % how many lines to skip
    trace_header_lines = 1;

    % *************** DIRS ***************
    % Intermediate result dir when reading full traces for sampled services.
    full_traces_dir = "../full_traces_by_svc";

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

    % *************** muBench Outputs ***************
    % Output file for service graph
    service_graph_output_file = "../service_graphs.json";
    % Output file for trace CSV
    trace_csv_output_file = "../sampled_traces.csv";
    % Output file for CSV containing the microservices with their earliest
    % call timestamp (when are they first required?)
    deployment_ts_output_file = "../sampled_deployment_ts.csv";
end