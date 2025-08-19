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
    interval_starts = passive_glo.start_time(interval_tag(passive_glo)) - prestim;
    interval_stops = passive_glo.stop_time(interval_tag(passive_glo)) + poststim;
    interval_lengths = mean(interval_stops - interval_starts);

    session.(area).fsample = round(1 / mean(diff(session.timestamps)));
    session.(area).(func2str(interval_tag)) = epoch_subject_lfps(session.(area), ...
        interval_starts, interval_stops);
    session.(area).(func2str(interval_tag)).unit_spikeseries = epoch_spikeseries( ...
        session.(area).units, session.timestamps, interval_starts, ...
        interval_stops);

    spikes_per_second = mean(sum(session.(area).(func2str(interval_tag)).unit_spikeseries(:, :, :), ...
        2), 3) / interval_lengths;
    accept = spikes_per_second > 1;
    session.(area).(func2str(interval_tag)).units_accepted = accept;
    session.(area).(func2str(interval_tag)).unit_spikeseries = session.(area).(func2str(interval_tag)).unit_spikeseries(accept, :, :);
end
end
