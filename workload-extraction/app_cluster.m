
function [services] = app_cluster(service_graphs, sharingT, napps)
    % an app is a set of "similar" services. Grouping performed according to the paper https://ieeexplore.ieee.org/abstract/document/9774016 
    % v_G_app{i} dependency graph of app #i
    % u_service_a{i} set of services that belongs to app #i
    % u_traceids_a{i} set of traces that belongs to app #i
    % services as returned by 'service_graphs' with these columns:
    % service: ID of the service ('interface')
    % trace_ids: list of trace_id that correspond to that service
    % graph: a digraph constructed using the available traces' upstream and downstream information
    % sharingT sharing threshold to declare two services as similar
    % napps number of applications to be generated, if <=0 then this number is computed as in the paper 
    
    h_services = height(service_graphs);
    similarity_matrix = zeros(h_services,h_services);
    node_names = cellfun(@getGraphNodeNames, service_graphs{:,2}, 'UniformOutput',false);

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
    if napps<=0
        k_opt=evalclusters(symmetric,myfunc,'CalinskiHarabasz','klist',2:50);
        napps = k_opt.OptimalK;
    end
    disp('Clustering...');
    clusters = spectralcluster(symmetric,napps);

    % append a column to the services table 
    % to hold the corresponding app (cluster)
    services = [service_graphs table(clusters)];
    services.Properties.VariableNames(3) = "app";
end

function [names] = getGraphNodeNames(graph)
    all_names = graph.Nodes.Name;
    names = all_names(strcmp(all_names, "USER") == 0);
end