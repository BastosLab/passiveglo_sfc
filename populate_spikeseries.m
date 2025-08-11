function [spikeseries] = populate_spikeseries(spike_times, timestamps)
spikeseries = zeros(size(timestamps));

spike_samples = dsearchn(timestamps, spike_times);
spikeseries(spike_samples) = 1;
end

