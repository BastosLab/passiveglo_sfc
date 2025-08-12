function [spikeseries] = epoch_spikeseries(area_units, timestamps, starts, stops)
start_samples = nearest_index(timestamps, starts);
stop_samples = nearest_index(timestamps, stops);
num_samples = round(mean(stop_samples - start_samples));
spikeseries = zeros(size(area_units.id, 1), num_samples+1, size(starts, 1));

for au=1:size(area_units.id, 1)
    unit_spike_times = area_units.unit_spike_times{au};
    fitting = unit_spike_times >= min(starts) & unit_spike_times <= max(stops);
    series = populate_spikeseries(unit_spike_times(fitting), timestamps);
    spikeseries(au, :, :) = epoch_data(series', start_samples, [0, num_samples]);
end
end

