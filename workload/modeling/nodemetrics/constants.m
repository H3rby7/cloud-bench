function [trace_header, trace_formats, trace_vartypes] = constants()
    % Constants, do not change!

    % trace table header
    trace_header = ["timestamp", "node_id", "cpu_utilization", "memory_utilization"];
    % trace variable types
    trace_formats = ["%d", "%s", "%f", "%f"];
    trace_vartypes = {'uint64', 'string', 'double', 'double'};
    
end