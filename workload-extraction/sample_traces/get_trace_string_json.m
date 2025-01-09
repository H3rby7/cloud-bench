function [output] = get_trace_string_json(dg)
    % Convert a sanitized trace for a trace_id to an muBench conformous
    % json text output
    % trace - The input trace
    % json - the output string

    body = rec(dg, "USER");
    json = ['{' body{1} '}'];
    output = horzcat(json{:});
end

function [out] = rec(digraph, node_name)
    % Recursively iterates over the digraph and creates a char array cell from it
    children = digraph.successors(node_name);
    if isempty(children)
        c_as_str = {''};
    else
        c_nodes = cellfun(@(c) rec(digraph, c), children);
        % output for parallel execution
        c_as_str = join(c_nodes, "},{", 1);
        % for sequential execution replace '},{' with ','
    end
    out = {['"' node_name '":[{' c_as_str{1} '}]']};
end
