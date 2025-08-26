function [session] = epoch_session_area(session_dir, area, interval_tags, units_mask)
session = session_area_channels(session_dir, area);
if exist('units_mask', 'var')
    session.(area).units = populate_area_units(session_dir, session.(area).channels, units_mask);
else
    session.(area).units = populate_area_units(session_dir, session.(area).channels);
end

session.(area).units.location = cell(size(session.(area).units.id, 1), 1);
spikeseries = zeros(size(session.(area).units.id, 1), size(session.timestamps, 1));
for u=1:size(session.(area).units.id, 1)
    channel = session.(area).units.channels(u);
    where = session.(area).channels.id == channel;
    session.(area).units.location{u} = session.(area).channels.location{where};
    spikeseries(u, :) = populate_spikeseries(session.(area).units.unit_spike_times{u}, ...
        session.timestamps)';
end
passive_glo = load([session_dir, '/', 'passiveglo_task_data.mat']);

for i=1:size(interval_tags, 1)
    [interval_tag, prestim, poststim] = interval_tags{i}(passive_glo);
    interval_starts = passive_glo.start_time(interval_tag) - prestim;
    interval_stops = passive_glo.stop_time(interval_tag) + poststim;
    interval_length = mean(interval_stops - interval_starts);

    session.(area).fsample = round(1 / mean(diff(session.timestamps)));
    session.(area).(func2str(interval_tags{i})) = epoch_subject_lfps(session.(area), ...
        interval_starts, interval_stops);
    session.(area).(func2str(interval_tags{i})).unit_spikeseries = epoch_spikeseries( ...
        spikeseries, session.timestamps, interval_starts, interval_stops);

    total_spikes = sum(session.(area).(func2str(interval_tags{i})).unit_spikeseries, [2, 3]);
    num_trials = size(session.(area).(func2str(interval_tags{i})).unit_spikeseries, 3);
    accepted = total_spikes / (interval_length * num_trials) > 1;
    session.(area).(func2str(interval_tags{i})).accepted = find(accepted);
    session.(area).(func2str(interval_tags{i})).unit_spikeseries = ...
        session.(area).(func2str(interval_tags{i})).unit_spikeseries(accepted, :, :);
end
end
