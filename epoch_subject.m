function [subject_series] = epoch_subject(subject_dir, area, interval_tag, prestim, poststim)
passive_glo = load([subject_dir, '/', 'passiveglo_task_data.mat']);
interval_starts = passive_glo.start_time(passive_glo.(interval_tag));
interval_stops = passive_glo.stop_time(passive_glo.(interval_tag));

subject_series = [];

probe_nwbs = dir([subject_dir, '/*_probe-*_ecephys.nwb']);
for probe=1:size(probe_nwbs, 1)
   probe_nwb = nwbRead([subject_dir, '/', probe_nwbs(probe).name]);
   electrodes = probe_nwb.general_extracellular_ephys_electrodes;
   locations = electrodes.vectordata.get("location").data(:);
   area_locations = contains(locations, area);
   
   if strcmp(common_prefix(locations(area_locations)), area)
       area_locations = find(area_locations);
       area_channels = [];
       area_channels.depth = electrodes.vectordata.get("probe_vertical_position").data(area_locations);
       area_channels.id = electrodes.id.data(area_locations);
       area_channels.local_index = electrodes.vectordata.get("local_index").data(area_locations);
       area_channels.location = electrodes.vectordata.get("location").data(area_locations);

       lfp = probe_nwb.acquisition.get(['probe_', int2str(probe-1), '_lfp']).electricalseries.get(['probe_', int2str(probe-1), '_lfp_data']);
       subject_series.timestamps = lfp.timestamps(:);
       start_samples = nearest_index(subject_series.timestamps, interval_starts - prestim);
       stop_samples = nearest_index(subject_series.timestamps, interval_stops + poststim);
       num_samples = round(mean(stop_samples - start_samples));

       subject_series.(area) = [];
       subject_series.(area).channels = area_channels;
       subject_series.(area).(interval_tag).timestamps = epoch_data( ...
           permute(subject_series.timestamps, [2, 1]), start_samples, [0, num_samples]);

       subject_series.(area).(interval_tag).lfp = epoch_data( ...
           lfp.data(area_locations, :), start_samples, [0, num_samples]);
       break;
   end
end
end

