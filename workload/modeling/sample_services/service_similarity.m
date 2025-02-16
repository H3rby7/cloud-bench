function [output] = service_similarity(services)
    % Create a similarity matrix of the input services
    % by calculating how well their representations with their
    % possible_node_names are (the RPC_ID representation) of th graph
    % We take this approach, because the RPC_ID naming contains information
    % about the topology of the graphs. This way we assume services to be
    % similar if their structure is similar.
    % The output holds the percentages, rather than 0 and 1, so the
    % threshold can be applied later and be experimented with.

    % NOTE: This function has high computational complexity and may take
    % very long!

    % Calculate only one half of the matrix to support parallel computing.

    % Example (letters are results):
    % 0 A B C D
    % 0 0 E F G
    % 0 0 0 H I
    % 0 0 0 0 J
    % 0 0 0 0 0

    % After computation is done make the matrix symmetric.
    
    h_services = height(services);
    similarity_matrix = zeros(h_services,h_services);
    possible_node_names = services.possible_node_names;

    % Compare each service with each other service
    parfor i = 1:h_services
        % Possible rpc_id representations of service 1
        possible_names_1 = possible_node_names{i};
        if height(possible_names_1) == 0
            continue;
        end

        % Container to hold the similarities to all other services
        similarity_row = zeros(1,h_services);
        
        for j = i+1:h_services
            % Possible rpc_id representations of service 2
            possible_names_2 = possible_node_names{j};
            if height(possible_names_2) == 0
                continue;
            end

            % Calculate similarity between service 1 and 2 and add it
            similarity = graph_similarity(possible_names_1, possible_names_2);
            similarity_row(1,j)=similarity;
        end

        % Add the similarities of this service to all other services to the
        % matrix
        similarity_matrix(i,:) = similarity_row;
    end

    % Make the result symmetric
    symmetric = similarity_matrix'+tril(similarity_matrix',-1).';
    disp('Similarity Matrix created.');
    output = symmetric;
end

function [max_sharing] = graph_similarity(possible_names_1, possible_names_2)
    % Find the highest share of node names between possible_names_1, possible_names_2

    % Size of node names for each input.
    % The width is the same for all rows so we use the first row.
    n1_length = width(possible_names_1{1});
    n2_length = width(possible_names_2{1});

    % Find the longer node_name list to calculate the sharing factor later
    max_length = max([n1_length n2_length]);

    % shared node_names
    max_sharing_count = 0;

    % Iterate over all combinations
    for i = 1:height(possible_names_1)
        n1 = possible_names_1{i};
        for j = 1:height(possible_names_2)
            n2 = possible_names_2{j};
            % Common node names of this combination
            common = sum(ismember(n1, n2));
            if (common > max_sharing_count)
                % new max value found
                max_sharing_count = common;
                if (max_sharing_count == max_length)
                    % Short-circuit the calculation as we found a 100%
                    % match (cannot get any higher)
                    max_sharing = 1;
                    return;
                end
            end
        end
    end

    % Sharing factor
    max_sharing = max_sharing_count / max_length;
end