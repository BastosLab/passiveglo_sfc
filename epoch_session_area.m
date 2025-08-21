function [session] = epoch_session_area(session_dir, area, interval_tags, units_mask)
session = session_area_channels(session_dir, area);
session_length = session.timestamps(end) - session.timestamps(1);
if exist('units_mask', 'var')
    session.(area).units = populate_area_units(session_dir, session.(area).channels, units_mask);
else
    session.(area).units = populate_area_units(session_dir, session.(area).channels);
end

session.(area).units.accepted = false(size(session.(area).units.id, 1), 1);
session.(area).units.location = cell(size(session.(area).units.id, 1), 1);
spikeseries = zeros(size(session.(area).units.id, 1), size(session.timestamps, 1));
for u=1:size(session.(area).units.id, 1)
    channel = session.(area).units.channels(u);
    where = session.(area).channels.id == channel;
    session.(area).units.location{u} = session.(area).channels.location{where};
    spikeseries(u, :) = populate_spikeseries(session.(area).units.unit_spike_times{u}, ...
        session.timestamps)';
end
session.(area).units.accepted = (sum(spikeseries, 2) / session_length) > 1;

accepted_units = [];
accepted_units.id = session.(area).units.id(session.(area).units.accepted);
accepted_units.channels = session.(area).units.channels(session.(area).units.accepted);
accepted_units.unit_index = session.(area).units.unit_index(session.(area).units.accepted);
accepted_units.unit_spike_times = session.(area).units.unit_spike_times(session.(area).units.accepted);
accepted_units.location = session.(area).units.location(session.(area).units.accepted);

passive_glo = load([session_dir, '/', 'passiveglo_task_data.mat']);

for i=1:size(interval_tags, 1)
    [interval_tag, prestim, poststim] = interval_tags{i}(passive_glo);
    interval_starts = passive_glo.start_time(interval_tag) - prestim;
    interval_stops = passive_glo.stop_time(interval_tag) + poststim;

    session.(area).fsample = round(1 / mean(diff(session.timestamps)));
    session.(area).(func2str(interval_tags{i})) = epoch_subject_lfps(session.(area), ...
        interval_starts, interval_stops);
    session.(area).(func2str(interval_tags{i})).unit_spikeseries = epoch_spikeseries( ...
        spikeseries(session.(area).units.accepted, :), session.timestamps, ...
        interval_starts, interval_stops);
end
end
