
function [clustered_services] = service_clustering(services, binary_similarity_matrix, n_clusters)
    % Grouping performed according to the paper https://ieeexplore.ieee.org/abstract/document/9774016
    % Returns the input 'services' together with their cluster
    % services as returned by 'service_graph_reducer', expecting these columns:
        % service_id: ID of the service
        % graph: a digraph constructed using the available traces' upstream and downstream information
    % binary_similarity_matrix
    % n_clusters number of clusters to use, if <=0 then this number is
    % computed as in the paper mentioned above.

    % optional: find ideal number of clusters
    if n_clusters<=0
        myfunc=@(X,K)(spectralcluster(X,K));
        k_opt=evalclusters(binary_similarity_matrix,myfunc,'CalinskiHarabasz','klist',2:50);
        n_clusters = k_opt.OptimalK;
    end

    % clustering of services
    fprintf("Clustering into %d clusters", n_clusters);
    clusters = spectralcluster(binary_similarity_matrix,n_clusters);

    % Create output table
    clustered_services = [services table(clusters)];
    % Label Columns
    clustered_services.Properties.VariableNames(width(clustered_services)) = "cluster";
end
