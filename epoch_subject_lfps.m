function [epoched_interval] = epoch_subject_lfps(session_area, starts, stops)
epoched_interval = [];

probe_nwb = nwbRead(session_area.nwb);
electrodes = probe_nwb.general_extracellular_ephys_electrodes;
locations = electrodes.vectordata.get("location").data(:);
area_locations = session_area.channels.local_index;

lfp = probe_nwb.acquisition.get(['probe_', int2str(session_area.probe-1), ...
    '_lfp']).electricalseries.get(['probe_', int2str(session_area.probe-1), '_lfp_data']);
timestamps = lfp.timestamps(:);
start_samples = nearest_index(timestamps, starts);
stop_samples = nearest_index(timestamps, stops);
num_samples = round(mean(stop_samples - start_samples));

epoched_interval.timestamps = epoch_data(permute(timestamps, [2, 1]), ...
    start_samples, [0, num_samples]);

epoched_interval.lfp = epoch_data(lfp.data(area_locations, :), ...
    start_samples, [0, num_samples]);
end

