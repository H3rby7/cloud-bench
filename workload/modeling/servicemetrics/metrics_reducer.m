function metrics_reducer(ms_name, intermValIter, outKVStore)
    ms_name = string(ms_name);
    % Accumulate results
    cpu_n = [];
    cpu_m = [];
    cpu_v = [];
    cpu_s = [];
    cpu_k = [];
    memory_n = [];
    memory_m = [];
    memory_v = [];
    memory_s = [];
    memory_k = [];
    while hasnext(intermValIter)
        value = getnext(intermValIter);
        cpu_n = [cpu_n; value(1)];
        cpu_m = [cpu_m; value(2)];
        cpu_v = [cpu_v; value(3)];
        cpu_s = [cpu_s; value(4)];
        cpu_k = [cpu_k; value(5)];
        memory_n = [memory_n; value(6)];
        memory_m = [memory_m; value(7)];
        memory_v = [memory_v; value(8)];
        memory_s = [memory_s; value(9)];
        memory_k = [memory_k; value(10)];
    end

    cpu_stats = combinestatsfun("cpu", cpu_n, cpu_m, cpu_v, cpu_s, cpu_k);
    memory_stats = combinestatsfun("memory", memory_n, memory_m, memory_v, memory_s, memory_k);
    
    outValue = [table(ms_name) cpu_stats memory_stats];

    add(outKVStore,ms_name,outValue);
end

function out = combinestatsfun(prefix, n, m, v, s, k)
    % Combine the intermediate results
    count = sum(n);
    meanVal = sum(n.*m)/count;
    d = m - meanVal;
    variance = (sum(n.*v) + sum(n.*d.^2))/count;
    skewnessVal = (sum(n.*s) + sum(n.*d.*(3*v + d.^2)))./(count*variance^(1.5));
    kurtosisVal = (sum(n.*k) + sum(n.*d.*(4*s + 6.*v.*d +d.^3)))./(count*variance^2);
    
    out = table(count, meanVal, variance, skewnessVal, kurtosisVal);
    out.Properties.VariableNames = [prefix+"_count", prefix+"_mean", prefix+"_variance", prefix+"_skewness", prefix+"_kurtosis"];

end