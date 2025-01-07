function [output] = service_similarity(services)
    
    h_services = height(services);
    similarity_matrix = zeros(h_services,h_services);
    possible_node_names = services.possible_node_names;

    parfor i = 1:h_services
        possible_names_1 = possible_node_names{i};
        if height(possible_names_1) == 0
            continue;
        end
        similarity_row = zeros(1,h_services);
        for j = i+1:h_services
            possible_names_2 = possible_node_names{j};
            if height(possible_names_2) == 0
                continue;
            end
            simmilarity = graph_similarity(possible_names_1, possible_names_2);
            similarity_row(1,j)=simmilarity;
        end
        similarity_matrix(i,:) = similarity_row;
    end
    symmetric = similarity_matrix'+tril(similarity_matrix',-1).';
    disp('Similarity Matrix created.');
    output = symmetric;
end

function [max_sharing] = graph_similarity(possible_names_1, possible_names_2)
    n1_length = width(possible_names_1{1});
    n2_length = width(possible_names_2{1});
    max_length = max([n1_length n2_length]);

    max_sharing_count = 0;
    for i = 1:height(possible_names_1)
        n1 = possible_names_1{i};
        for j = 1:height(possible_names_2)
            n2 = possible_names_2{j};
            % use node names to calculate similarity between two service graphs
            common = sum(ismember(n1, n2));
            if (common > max_sharing_count)
                % new max value found
                max_sharing_count = common;
                if (max_sharing_count == max_length)
                    max_sharing = 1;
                    return;
                end
            end
        end
    end
    max_sharing = max_sharing_count / max_length;
end