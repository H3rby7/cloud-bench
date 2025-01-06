% edge_table = ["USER" "Root"; 
%               "Root" "S_1"; 
%               "Root" "S_2"; 
%               "Root" "S_3"; 
%               "S_1" "S_1_1"; 
%               "S_1" "S_1_2"; 
%               "S_2" "S_2_1"; 
%               "S_2" "S_2_2"; 
%               "S_2" "S_2_3";
%               "S_1_2" "S_2_1"];
edge_table = ["USER" "MS_48247";
"MS_48247"    "MS_19585";
"MS_48247"    "MS_68650";
"MS_48247"    "MS_27421";
"MS_48247"    "MS_40991";
"MS_68650"    "MS_19585";
"MS_68650"    "MS_27421";
"MS_68650"    "MS_15303"];

g = digraph(edge_table(:,1), edge_table(:,2));
tic
result = graph_nodes_as_rpc_ids(g, 10);
toc
disp(result);
plot(g);


function [node_name_options] = graph_nodes_as_rpc_ids(graph, max_permutations)
    if max_permutations > 15 
        error("max_permutations must be smaller than 16 as otherwise maximum variable size is exceeded.")
    end
    opts = node_options(graph, "USER", "0", max_permutations);
    node_name_options = opts;
end


function [output] = node_options(graph, node, rpc_id, max_permutations)
    % Get all naming options for this node and its successors
    % As we do not know if the first of n successors would be .1 or .n
    children = graph.successors(node);
    child_count = height(children);
    if child_count == 0
        % no children -> leaf node
        output = {rpc_id};
        return
    end

    % calculate permutations for children
    [permutations, statics] = get_permutations_and_statics(graph, node, max_permutations);
    permutation_count = height(permutations);

    % holds 1 cell as entry per permutation
    % cell can have multiple results, as children may also have more than
    % one naming options
    permuted_name_options = cell(permutation_count,1);
    for i=1:permutation_count
        child_order = permutations(i,:);
        permuted_name_options{i} = get_name_options_for_child_order(graph, children, rpc_id, child_order, max_permutations);
    end

    % the list may contain duplicate names, we filter them out to prevent
    % double computations when passing the result back up
    flattened = vertcat(permuted_name_options{:});
    [~, unique_idx] = unique(cell2table(flattened));
    permuted_unique_name_options = flattened(unique_idx,:);

    if (width(statics) == 0)
        % No static appending needed, can take output immediately
        output = permuted_unique_name_options;
        return;
    end

    static_names = get_name_options_for_child_order(graph, children, rpc_id, statics, max_permutations);
    for i=1:height(permuted_unique_name_options)
        permuted_unique_name_options{i} = [permuted_unique_name_options{i} static_names];
    end
    output = permuted_unique_name_options;
end

function [permutations, statics] = get_permutations_and_statics(graph, node, max_permutations)
    children = graph.successors(node);
    child_count = height(children);

    % array holding the indeces of the children
    child_idx = (1:child_count)';

    % graph depths for each child
    depths = zeros(child_count,1);

    % maximum depth across all children
    max_depth = 0;
    for i=1:child_count
        d = distances(graph,children(i));
        depths(i) = max(d(d ~= Inf));
        if (max_depth < depths(i))
            max_depth = depths(i);
        end
    end

    % sort children by depths, as higher depth will potentially hold more information
    sorted_by_depths = sortrows(table(child_idx, depths), "depths", "desc");
    sorted_children = sorted_by_depths.child_idx';

    statics = [];
    if max_depth == 0
        % all children at hand are leafs, so the permutations do not matter
        % Create the simplest permutation from sorted child_idx
        permutations = sorted_children;
        return
    end
    if child_count <= max_permutations
        permutations = perms(sorted_children);
        return
    end
    statics = sorted_children(max_permutations+1:child_count);
    permutations = sorted_children(1:max_permutations);
end

function [output] = get_name_options_for_child_order(graph, children, rpc_id, child_order, max_permutations)

    child_count = width(child_order);
    % should hold 1 entry cell per child
    % cell can have multiple results, as children may also have more than
    % one naming options
    permutation_options = cell(child_count,1);

    % within the permutation we get the potential node names for
    % all children
    for j=1:child_count
        % id_opt -> the suggested rpc_id based on the permutation
        id_opt = rpc_id + "." + child_order(j);

        % get all node-name combination of successors, given we had
        % used the id_opt as this child's node_name
        child_options = node_options(graph, children(j), id_opt, max_permutations);
        permutation_options{j} = child_options;
    end

    % flatten the nodenames as in the end we want a string array
    flattened = flatten_permutations(permutation_options);
    
    all_node_name_options = cell(height(flattened),1);
    for j=1:height(flattened)
        % prepend all options with rpc_id and add them to the list
        all_node_name_options{j} = [rpc_id sort(flattened{j})];
    end
    output = all_node_name_options;
end

function [output] = flatten_permutations(permutation_options)
    % permutation_options contains a cell of varying size for each child
    % within each cell combinations of potential node_names reside
    % we need to combine all entries with all other entries to get all
    % possible combinations across the children entries
    % Approach: 'mulitply' them one-by-one

    % take the first entry as base
    flattened = permutation_options{1};

    % start the loop with the second item
    for i=2:height(permutation_options)

        % options until now
        current_size = height(flattened);

        % options presented by the next item to multiply with
        next_el_size = height(permutation_options(i));

        % create an intermediate result cell
        tmp_i = cell(current_size,1);

        for o=1:current_size

            % item from the already combined options
            option = flattened{o};

            % create an intermediate result to hold the results of this one
            % item and the items of 'next'
            tmp_o = cell(next_el_size, 1);

            for n=1:next_el_size
                % combine the next item and the already combined option
                next = permutation_options{i}{n};
                tmp_o{n} = [option{:} next];
            end
            tmp_i{o} = tmp_o;
        end
        flattened = tmp_i{:};
    end
    output = flattened;
end