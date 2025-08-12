function [session] = session_area_channels(subject_dir, area)
session = [];

probe_nwbs = dir([subject_dir, '/*_probe-*_ecephys.nwb']);
for probe=1:size(probe_nwbs, 1)
   probe_nwb = nwbRead([subject_dir, '/', probe_nwbs(probe).name]);
   electrodes = probe_nwb.general_extracellular_ephys_electrodes;
   locations = electrodes.vectordata.get("location").data(:);
   area_locations = contains(locations, area);
   
   if strcmp(common_prefix(locations(area_locations)), area)
       lfp = probe_nwb.acquisition.get(['probe_', int2str(probe-1), '_lfp']).electricalseries.get(['probe_', int2str(probe-1), '_lfp_data']);
       session.timestamps = lfp.timestamps(:);

       area_locations = find(area_locations);
       session.(area) = [];
       session.(area).nwb = [subject_dir, '/', probe_nwbs(probe).name];
       session.(area).probe = probe;
       session.(area).channels = [];
       session.(area).channels.depth = electrodes.vectordata.get("probe_vertical_position").data(area_locations);
       session.(area).channels.id = electrodes.id.data(area_locations);
       session.(area).channels.local_index = electrodes.vectordata.get("local_index").data(area_locations);
       session.(area).channels.location = electrodes.vectordata.get("location").data(area_locations);
       break;
   end
end
end

