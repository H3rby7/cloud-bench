function [ms_names] = getGraphMsNames(graph)
    % Get MS names of the graph
    % The resulting names will be unique
    all_names = graph{:}.Nodes.Name';
    unique_names = unique(all_names);
    ms_names = string(unique_names);
end