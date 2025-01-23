function [output] = to_mubench_trace_json(input)
    % Take all json 'below' "USER" node
    % Make names k8s-conformous
    output = cell(height(input),1);
    for i=1:height(input)
        % rm 'USER' from json string
        w_o_user = extractAfter(input(i),'{"USER":[');
        str_len = strlength(w_o_user);
        % rm corresponding brackets from json string
        % We want to remove the last two characters, since this function is
        % suddenly 0-indexed we work with str_len - 1
        valid_json = extractBefore(w_o_user, str_len -1);
        output{i} = k8s_conformous(valid_json);
    end
end