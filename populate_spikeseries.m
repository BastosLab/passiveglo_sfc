function [spikeseries] = populate_spikeseries(spike_times, timestamps)
spikeseries = zeros(size(timestamps));
dt = mean(diff(timestamps));
for s=1:size(spike_times, 1)
    spiketime_indices = find(abs(timestamps - spike_times(s)) <= dt);
    for i=1:size(spiketime_indices, 1)
        t = spiketime_indices(i);
        spikeseries(t) = 1;
    end
end
end

