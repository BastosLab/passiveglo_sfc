function [area_units] = populate_area_units(session_dir, area_channels)
ogen_nwbs = dir([session_dir, '/*_ogen.nwb']);
nwb = nwbRead([session_dir, '/', ogen_nwbs(1).name]);
unit_channels = nwb.units.vectordata.get("peak_channel_id").data(:);

area_units_mask = area_channels.id(1) <= unit_channels & unit_channels <= area_channels.id(end);
unit_index = 1:size(unit_channels, 1);

area_units = [];
area_units.id = nwb.units.id.data(find(area_units_mask));
area_units.channels = unit_channels(area_units_mask);
area_units.unit_index = unit_index(area_units_mask);
area_units.unit_spike_times = cell(sum(area_units_mask), 1);

for au=1:size(area_units.unit_spike_times, 1)
   u = area_units.unit_index(au);
   if u > 1
       unit_start = nwb.units.spike_times_index.data(u-1) + 1;
   else
       unit_start = 1;
   end
   unit_end = nwb.units.spike_times_index.data(u);
   area_units.unit_spike_times{au} = nwb.units.spike_times.data(unit_start:unit_end);
end
end

