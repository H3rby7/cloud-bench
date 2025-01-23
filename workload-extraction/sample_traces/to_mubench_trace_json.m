function [output] = to_mubench_trace_json(input)
    % Remove "USER" from json
    % Make names k8s-conformous

    % TODO: using struct conversion the [{"svc":[{}]}] bracket construct
    % breaks, need to work with string magic instead!
    output = cell(height(input),1);
    for i=1:height(input)
        as_struct = jsondecode(input{i});
        w_o_user = jsonencode(as_struct.USER);
        output{i} = k8s_conformous(w_o_user);
    end
end