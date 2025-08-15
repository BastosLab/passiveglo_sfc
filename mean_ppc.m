function [w_ppc,uw_ppc,thresh_ppc] = mean_ppc(num_spikes, units_ppc)
% compute weighted ppc
num_units = size(units_ppc, 1);
num_spikes = permute(num_spikes, [1, 3, 2]);
w_ppc = sum(units_ppc .* num_spikes ./ repmat(sum(num_spikes, 1), [num_units 1]), 1);

% unweighted average 
uw_ppc = mean(units_ppc, 1);

% threshold of 50 spikes
units_ppc_thresholded = units_ppc; 
units_ppc_thresholded(num_spikes < 50) = NaN;
thresh_ppc = mean(units_ppc_thresholded, 1); 
end
