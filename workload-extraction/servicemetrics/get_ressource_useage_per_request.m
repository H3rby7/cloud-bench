function [output] = get_ressource_useage_per_request(input_data)
    ms_names = unique(input_data.ms_name);
    ms_count = height(ms_names);
    
    output = table();
    
    for c=1:ms_count
        ms_name = string(ms_names{c});
        ms_data = input_data(strcmp(input_data.ms_name, ms_name),:);
        min_requests = min(ms_data.requests);
        max_requests = max(ms_data.requests);

        base_memory = ms_data.mean_memory_utilization(ms_data.requests == min_requests);
        base_cpu = ms_data.mean_cpu_utilization(ms_data.requests == min_requests);

        max_memory = ms_data.mean_memory_utilization(ms_data.requests == max_requests);
        max_cpu = ms_data.mean_cpu_utilization(ms_data.requests == max_requests);
        
        max_to_min_request_count_diff = max_requests - min_requests;

        memory_per_request = (max_memory - base_memory) / max_to_min_request_count_diff;
        cpu_per_request = (max_cpu - base_cpu) / max_to_min_request_count_diff;

        output = [output; table(ms_name, base_cpu, cpu_per_request, base_memory, memory_per_request)];
    end

end