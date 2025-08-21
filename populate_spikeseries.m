function [spikeseries] = populate_spikeseries(spike_times, timestamps)
spikeseries = zeros(size(timestamps, 1), 1);
dt = mean(diff(timestamps));
within = spike_times >= timestamps(1) & spike_times <= timestamps(end);
spike_times = spike_times(within);

spike_samples = int64(floor((spike_times - timestamps(1)) / dt));
spikeseries(spike_samples, :) = 1;
assert(size(spikeseries, 1) == size(timestamps, 1));
end

