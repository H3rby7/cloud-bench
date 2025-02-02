function [trace_header, trace_formats, trace_vartypes] = trace_constants()
    % Constants, do not change!

    % trace table header
    trace_header = ["timestamp", "trace_id", "service", "rpc_id", "rpc_type", "upstream_ms", "upstream_instance", "interface", "downstream_ms", "downstream_instance", "response_time"];
    % trace variable types
    % "response_time" and "timestamp" are technically a '%d' and '%f', 
    % however the CSVs contain invalid rows that result in parsing errors
    % when reading in the tabularDatastore
    % We work around this by treating everything as '%s' and parse it ourselves within the code
    trace_formats = ["%s", "%s", "%s", "%s", "%s", "%s", "%s", "%s", "%s", "%s", "%s"];
    trace_vartypes = {'uint64', 'string', 'string', 'string', 'string', 'string', 'string', 'string', 'string', 'string', 'double'};
    
end