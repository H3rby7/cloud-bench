function create_service_ressources_for_mbench(ressources, outputFile)
    ms_count = height(ressources);

    js = "{";
    for i = 1:ms_count
        % ADD "ms-001":{
        js = js + char(34)+k8s_conformous(ressources.ms_name(i))+char(34)+":{";
        % ADD "cpu":{
        js = js + char(34)+"cpu"+char(34)+":{";
        % ADD "min":VAL,
        js = js + char(34)+"min"+char(34)+":"+ressources.min_cpu_utilization(i)+",";
        % ADD "max":VAL},
        js = js + char(34)+"max"+char(34)+":"+ressources.max_cpu_utilization(i)+"},";
        % ADD "memory":{
        js = js + char(34)+"memory"+char(34)+":{";
        % ADD "mean":VAL},
        js = js + char(34)+"mean"+char(34)+":"+ressources.mean_memory_utilization(i)+"},";
        % ADD "disk":{
        js = js + char(34)+"disk"+char(34)+":{";
        % ADD "mean":VAL}}
        js = js + char(34)+"mean"+char(34)+":"+ressources.mean_disk_utilization(i)+"}}";
        if i~=ms_count
            js = js + ",";
        end
    end
    js = js + "}";
    fid = fopen(outputFile,'w');
    fprintf(fid,"%s",js);
    fclose(fid);
end