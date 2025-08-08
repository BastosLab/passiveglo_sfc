function [prefix] = common_prefix(sequence)
if size(sequence, 1) == 0
    prefix = '';
    return;
end
prefix = sequence{1};
for i=2:size(sequence, 1)
    [d, dist, prefix] = LCS(prefix, sequence{i});
end
end

