function [service_samples_export_file, ms_metrics_location, ms_metrics_header_lines, ms_metrics_max_timestamp, full_traces_dir, metrics_output_file] = config()
    % Adjust the variables in this block to your needs and conditions

    % *************** Service Samples ***************
    % Result from clustering and sampling the services
    service_samples_export_file = "../sampled_services_export.mat";

    % *************** Metrics options ***************
    % metrics_location of alibaba cluster trace microservices v2022
    % ms_metrics_location = "../../traces/alibaba/2022-ms/MsMetrics/MSMetricsUpdate_test.csv";

    % with the first two files to cover our one hour interval
    % https://aliopentrace.oss-cn-beijing.aliyuncs.com/v2022MicroservicesTraces/MSMetricsUpdate/MSMetricsUpdate_0.tar.gz
    % https://aliopentrace.oss-cn-beijing.aliyuncs.com/v2022MicroservicesTraces/MSMetricsUpdate/MSMetricsUpdate_1.tar.gz
    ms_metrics_location = "../../traces/alibaba/2022-ms/MsMetrics/input";
    % how many lines to skip
    ms_metrics_header_lines = 1;
    % maximum timestamp (12 hours)
    ms_metrics_max_timestamp = 12 * 60 * 60 * 1000;

    % *************** DIRS ***************
    % Intermediate result dir when reading full traces for sampled services.
    full_traces_dir = "../full_traces_by_svc";

    % *************** Outputs ***************
    % Output file for metrics extrema
    metrics_output_file = "../metrics_stats_normalized.csv";

end