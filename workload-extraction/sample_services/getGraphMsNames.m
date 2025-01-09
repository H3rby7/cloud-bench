function [ms_names] = getGraphMsNames(graph)
    % Get MS names of the graph
    % The resulting names will be unique and not contain the "USER" node.
    all_names = graph{:}.Nodes.Name';
    user_idx = strcmp(all_names, "USER");
    unique_names = unique(all_names(~user_idx));
    ms_names = string(unique_names);
end