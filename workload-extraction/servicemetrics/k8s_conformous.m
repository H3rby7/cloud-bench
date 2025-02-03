function [conformous] = k8s_conformous(input)
    % Convert input to lowercase and '_' to '-' 
    % to conform with K8s naming restrictions.
    conformous = replace(lower(input),'_', '-');
end