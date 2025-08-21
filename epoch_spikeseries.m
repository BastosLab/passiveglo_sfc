function [epoched] = epoch_spikeseries(spikeseries, timestamps, starts, stops)
start_samples = nearest_index(timestamps, starts);
stop_samples = nearest_index(timestamps, stops);
num_samples = round(mean(stop_samples - start_samples));
epoched = epoch_data(spikeseries, start_samples, [0, num_samples]);
end

