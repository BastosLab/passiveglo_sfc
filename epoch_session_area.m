function [session] = epoch_session_area(session_dir, area, interval_tag, prestim, poststim, units_mask)
passive_glo = load([session_dir, '/', 'passiveglo_task_data.mat']);
interval_starts = passive_glo.start_time(passive_glo.(interval_tag)) - prestim;
interval_stops = passive_glo.stop_time(passive_glo.(interval_tag)) + poststim;

session = epoch_subject_lfps(session_dir, area, interval_tag, ...
    interval_starts, interval_stops);
if exist('units_mask', 'var')
    session.(area).units = populate_area_units(session_dir, session.(area).channels, units_mask);
else
    session.(area).units = populate_area_units(session_dir, session.(area).channels);
end
session.(area).units.unit_spikeseries = epoch_spikeseries(session.(area).units, ...
    session.timestamps, interval_starts, interval_stops);
end

