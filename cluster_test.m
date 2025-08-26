function [significant] = cluster_test(xs, ys, permutations, alpha)
k = nan(permutations, 1);
data = permute(cat(3, xs, ys), [3, 1, 2]);

[significance_real, ~, ~, s_real] = ttest2(permute(xs, [3, 1, 2]), ...
    permute(ys, [3, 1, 2]), 'Alpha', alpha);

xtrials = size(xs, 3);
ytrials = size(ys, 3);

for p=1:permutations
    permutation = randperm(size(data, 1));
    permuted = data(permutation, :, :);
    [h_sim, ~, ~, s_sim] = ttest2(permuted(1:xtrials, :, :), ...
        permuted(xtrials+1:xtrials+ytrials, :, :), 'Alpha', alpha);

    [labels, num_clusters] = spm_bwlabel(h_sim, 18); % 18 for edge connectivity
    largest_cluster_size = 1;
    for c=1:num_clusters
        cluster_size = sum(abs(s_sim.tstat(labels == c)), 'all');
        if cluster_size > largest_cluster_size
            largest_cluster_size = cluster_size;
        end
    end
    k(p) = largest_cluster_size;
end

critical_bin = max([round(alpha * permutations), 1]);
[ks, ~] = sort(k, 'descend');
critical_k = ks(critical_bin);

[labels, num_clusters] = spm_bwlabel(significance_real, 18);
significant = labels;
for c=1:num_clusters
    if sum(abs(s_real.tstat(labels == critical_k)), 'all') < critical_k
        significant(labels == c) = 0;
    end
end
end

