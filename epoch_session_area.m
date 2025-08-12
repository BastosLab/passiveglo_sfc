function [session] = epoch_session_area(session_dir, area, interval_tags, prestim, poststim, units_mask)
session = session_area_channels(session_dir, area);

if exist('units_mask', 'var')
    session.(area).units = populate_area_units(session_dir, session.(area).channels, units_mask);
else
    session.(area).units = populate_area_units(session_dir, session.(area).channels);
end

passive_glo = load([session_dir, '/', 'passiveglo_task_data.mat']);

for i=1:size(interval_tags, 1)
    interval_tag = interval_tags{i};
    interval_starts = passive_glo.start_time(passive_glo.(interval_tag)) - prestim;
    interval_stops = passive_glo.stop_time(passive_glo.(interval_tag)) + poststim;

    session.(area).(interval_tag) = epoch_subject_lfps(session.(area), ...
        interval_starts, interval_stops);
    session.(area).(interval_tag).unit_spikeseries = epoch_spikeseries( ...
        session.(area).units, session.timestamps, interval_starts, ...
        interval_stops);
end
end
