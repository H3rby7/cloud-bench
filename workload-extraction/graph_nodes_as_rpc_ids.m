function [node_name_options] = graph_nodes_as_rpc_ids(graph)
    opts = node_options(graph, "USER", "0");
    node_name_options = opts;
end


function [unique_node_name_options] = node_options(graph, node, rpc_id)
    % Get all naming options for this node and its successors
    % As we do not know if the first of n successors would be .1 or .n
    children = graph.successors(node);
    child_count = height(children);
    if child_count == 0
        % no children -> leaf node
        unique_node_name_options = {rpc_id};
        return
    end
    % calculate permutations for children
    permutations = perms(1:child_count);

    grand_child_count = 0;
    for i=1:child_count
        grand_child_count = grand_child_count + height(graph.successors(children(i)));
    end
    if grand_child_count == 0
        % all children at hand are leafs, so the permutations do not matter
        permutations = permutations(1,:);
    end
    permutation_count = height(permutations);

    % holds 1 cell as entry per permutation
    % cell can have multiple results, as children may also have more than
    % one naming options
    all_node_name_options = cell(permutation_count,1);
    for i=1:permutation_count

        % should hold 1 entry cell per child
        % cell can have multiple results, as children may also have more than
        % one naming options
        permutation_options = cell(child_count,1);

        % within the permutation we get the potential node names for
        % all children
        for j=1:child_count
            % id_opt -> the suggested rpc_id based on the permutation
            id_opt = rpc_id + "." + permutations(i, j);

            % get all node-name combination of successors, given we had
            % used the id_opt as this child's node_name
            child_options = node_options(graph, children(j), id_opt);
            permutation_options{j} = child_options;
        end

        % flatten the nodenames as in the end we want a string array
        flattened = flatten_permutations(permutation_options);
        
        all_node_name_options{i} = cell(height(flattened),1);
        for j=1:height(flattened)
            % prepend all options with rpc_id and add them to the list
            all_node_name_options{i}{j} = [rpc_id sort(flattened{j})];
        end

    end

    % the list may contain duplicate names, we filter them out to prevent
    % double computations when passing the result back up
    flattened = vertcat(all_node_name_options{:});
    [~, unique_idx] = unique(cell2table(flattened));
    unique_node_name_options = flattened(unique_idx,:);
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