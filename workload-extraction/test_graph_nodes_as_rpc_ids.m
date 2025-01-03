edge_table = ["USER" "S_Root"; "Root" "S_1"; "Root" "S_2"; "S_1" "S_1_1"; "S_1" "S_1_2"];

g = digraph(edge_table(:,1), edge_table(:,2));

result = graph_nodes_as_rpc_ids(g);

disp(result);


function [node_name_options] = graph_nodes_as_rpc_ids(graph)
    opts = node_options(graph, "Root", "0.1");
    node_name_options = opts;
end


function [unique_node_name_options] = node_options(graph, node, rpc_id)
    children = graph.successors(node);
    child_count = height(children);
    if child_count == 0
        unique_node_name_options = {rpc_id};
        return
    end
    permutations = perms(1:child_count);
    permutation_count = height(permutations);
    % holds 1 entry per permutation
    % entry can have multiple results
    all_node_name_options = cell(permutation_count,1);
    for i=1:permutation_count
        % should hold 1 entry per child
        % entry can have multiple results
        permutation_options = cell(child_count,1);
        for j=1:child_count
            id_opt = rpc_id + "." + permutations(j, i);
            child_options = node_options(graph, children(j), id_opt);
            permutation_options{j} = child_options;
        end
        flattened = flatten_permutations(permutation_options);
        all_node_name_options{i} = [rpc_id sort(flattened{:})];
    end
    [~, unique_idx] = unique(cell2table(all_node_name_options));
    unique_node_name_options = all_node_name_options(unique_idx,:);
end


function [output] = flatten_permutations(permutation_options)
    flattened = permutation_options{1};
    for i=2:height(permutation_options)
        current_size = width(flattened);
        next_el_size = width(permutation_options(i));
        tmp_i = cell(1, current_size);
        for o=1:current_size
            option = flattened{o};
            tmp_o = cell(1, next_el_size);
            for n=1:next_el_size
                next = permutation_options{i}{n};
                tmp_o{n} = [option next];
            end
            tmp_i{o} = tmp_o;
        end
        % must horzcat or something
        flattened = tmp_i;
    end
    output = flattened{1};
end