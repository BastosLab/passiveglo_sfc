function [spikeseries] = populate_spikeseries(spike_times, timestamps)
spikeseries = zeros(size(timestamps));
dt = mean(diff(timestamps));

spike_samples = round(spike_times / dt);
spikeseries(spike_samples) = 1;
end

