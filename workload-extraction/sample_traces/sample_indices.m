function [sampled_idx] = sample_indices(totalCount, factor)
    nth_el = 1 / factor;
    sampled_idx = round(1:nth_el:totalCount);
end