
function [clustered_services] = service_clustering(services, sharingT, n_clusters)
    % Grouping performed according to the paper https://ieeexplore.ieee.org/abstract/document/9774016
    % Returns the input 'services' together with their cluster
    % services as returned by 'service_graph_reducer', expecting these columns:
        % service_id: ID of the service
        % graph: a digraph constructed using the available traces' upstream and downstream information
    % sharingT sharing threshold to declare two services as similar
    % n_clusters number of clusters to use, if <=0 then this number is
    % computed as in the paper mentioned above.
    
    h_services = height(services);
    similarity_matrix = zeros(h_services,h_services);
    node_names = cellfun(@getGraphNodeNames, services.graph, 'UniformOutput',false);

    parfor i = 1:h_services
        names1 = node_names{i};
        if height(names1) == 0
            continue;
        end
        similarity_row = zeros(1,h_services);
        for j = i+1:h_services
            names2 = node_names{j};
            if height(names2) == 0
                continue;
            end
            % use node names to calculate similarity between two service graphs
            common = sum(ismember(names1, names2));
            %fprintf("%d, %d common %d\n",i,j,common);
            if(common>sharingT*length(names1) && common>sharingT*length(names2))
              similarity_row(1,j)=1;
            end
        end
        similarity_matrix(i,:) = similarity_row;
    end
    symmetric = similarity_matrix'+tril(similarity_matrix',-1).';
    disp('Similarity Matrix created.');
    % clustering for findings apps
    myfunc=@(X,K)(spectralcluster(X,K));
    if n_clusters<=0
        k_opt=evalclusters(symmetric,myfunc,'CalinskiHarabasz','klist',2:50);
        n_clusters = k_opt.OptimalK;
    end
    disp('Clustering...');
    clusters = spectralcluster(symmetric,n_clusters);

    % Create output table
    clustered_services = [services table(clusters)];
    % Label Columns
    clustered_services.Properties.VariableNames(5) = "cluster";
end

function [names] = getGraphNodeNames(graph)
    % Get all node names excluding the "USER" node
    all_names = graph.Nodes.Name;
    names = all_names(strcmp(all_names, "USER") == 0);
end