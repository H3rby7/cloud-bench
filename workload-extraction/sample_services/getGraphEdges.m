function [edges] = getGraphEdges(graph)
    % Return edges of the graph in a cell
    edges = {graph{:}.Edges};
end