function create_service_graph_parameters_for_mbench(involved_ms, outputFile)

    % Static JS body string to be used in the loop later
    % attributes of jsbody will not be used, when running trace-based.
    % We still need it to run the conversion to K8s yamls.
    jsbody = ": {" + char(34)+"external_services"+char(34)+": [{";
    jsbody = jsbody + char(34)+"seq_len"+char(34)+": 10000,";
    jsbody = jsbody + char(34)+"services"+char(34)+": []}]}";
    
    % create a dummy service_graph.json file to be used with workmodel generator
    % and traces
    js = "{";
    for i = 1:length(involved_ms)
        js = js + char(34)+k8s_conformous(involved_ms(i))+char(34)+jsbody;
        if i~=length(involved_ms)
            js = js + ",";
        end
    end
    js = js + "}";
    fid = fopen(outputFile,'w');
    fprintf(fid,"%s",js);
    fclose(fid);
end