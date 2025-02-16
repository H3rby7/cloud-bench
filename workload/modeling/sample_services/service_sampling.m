
function [service_samples] = service_sampling(service_clusters, sampling_factor)
    % service_clusters as returned by 'service_clustering', expecting these columns:
        % service_id: ID of the service
        % graph: a digraph constructed using the available traces' upstream and downstream information
    % sampling_factor as reduction factor
    % service_samples: The selected services. As it is not possible to
    % TODO: explain 'trace_factor'
    
    cluster_count = max(service_clusters.cluster);
    n_step = 1 / sampling_factor;
    service_sample_cells = cell(cluster_count, 1);

    % parfor
    for i = 1:cluster_count
        idx = service_clusters.cluster == i;
        all_services = sortrows(service_clusters(idx,:),"trace_count", "descend");

        % this many services we want to use in the end
        target_service_count = ceil(height(all_services) * sampling_factor);
        % this many traces would correspond to the sample
        target_trace_count = sum(all_services.trace_count) * sampling_factor;
        
        sampled_services = all_services(1,:);

        for s = 1:(target_service_count-1)
            sample_idx = 1 + (s * n_step);
            % take services with diverse trace_counts
            sampled_services = [sampled_services; all_services(sample_idx,:)];
        end

        % the trace_count of the sampled services will not match the
        % desired outcome, so we calculate the factor to reduce the trace
        % count by
        sample_trace_count = sum(sampled_services.trace_count);
        trace_sample_factor = target_trace_count / sample_trace_count;
        if (trace_sample_factor > 1)
            disp("WARN: Cluster %d: We expected all 'trace_sample_factors' to be smaller than 1!", i);
        end

        % mainly for metadata to see the trace share of the service within
        % it's cluster
        service_cluster_share = zeros(target_service_count, 1);
        for s = 1:target_service_count
            service_cluster_share(s) = sampled_services.trace_count(s) / sample_trace_count;
        end

        % array holding the trace_factor (the same for all services within
        % this cluster
        trace_factor = zeros(target_service_count, 1) + trace_sample_factor;

        output = [sampled_services(:,:) table(service_cluster_share) table(trace_factor)];
        service_sample_cells{i} = output;
    end

    % Flatten into one table only.
    service_samples = vertcat(service_sample_cells{:,1});
end
