function [trace_header, trace_formats, trace_vartypes] = constants()
    % Constants, do not change!

    % trace table header
    trace_header = ["timestamp", "trace_id", "service", "rpc_id", "rpc_type", "upstream_ms", "upstream_instance", "interface", "downstream_ms", "downstream_instance", "response_time"];
    % trace variable types
    trace_formats = ["%d", "%s", "%s", "%s", "%s", "%s", "%s", "%s", "%s", "%s", "%f"];
    trace_vartypes = {'uint64', 'string', 'string', 'string', 'string', 'string', 'string', 'string', 'string', 'string', 'double'};
    
end