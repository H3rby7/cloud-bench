
function [clustered_services] = service_clustering(services, binary_similarity_matrix, n_clusters)
    % Grouping performed according to the paper https://ieeexplore.ieee.org/abstract/document/9774016
    % Returns the input 'services' together with their cluster
    % services as returned by 'service_graph_reducer', expecting these columns:
        % service_id: ID of the service
        % graph: a digraph constructed using the available traces' upstream and downstream information
    % binary_similarity_matrix

    % clustering of services
    fprintf("Clustering into %d clusters", n_clusters);
    clusters = spectralcluster(binary_similarity_matrix,n_clusters);

    % Create output table
    clustered_services = [services table(clusters)];
    % Label Columns
    clustered_services.Properties.VariableNames(width(clustered_services)) = "cluster";
end
