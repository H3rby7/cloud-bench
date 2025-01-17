function [sampled_idx] = sample_indices(totalCount, factor)
    sampled_idx = rand(totalCount, 1) < factor;
end