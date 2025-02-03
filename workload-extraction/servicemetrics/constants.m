function [ms_metrics_header, ms_metrics_formats, ms_metrics_vartypes] = constants()
    % Constants, do not change!

    % ms_metrics table header
    ms_metrics_header = ["timestamp", "ms_name", "ms_instance_id", "node_id", "cpu_utilization", "memory_utilization"];
    % ms_metrics variable types
    ms_metrics_formats = ["%d", "%s", "%s", "%s", "%f", "%f"];
    ms_metrics_vartypes = {'uint64', 'string', 'string', 'string', 'double', 'double'};
    
end