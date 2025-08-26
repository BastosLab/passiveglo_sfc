function [ws] = wppcs(ppcs)
ws = ppcs;
conditions = fieldnames(ppcs);
for c=1:size(conditions, 1)
    ppc = ppcs.(conditions{c}).ppc;
    num_spikes = ppcs.(conditions{c}).num_spikes;
    ws.(conditions{c}).wppc = sum(squeeze(ppc) .* num_spikes, 1) ./ sum(num_spikes, 1);
end
end

