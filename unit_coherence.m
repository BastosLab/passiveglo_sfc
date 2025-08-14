function [freqs, sfc] = unit_coherence(area, unit, condition, trials)
if ~exist('trials', 'var')
    trials = true(size(area.(condition).lfp, 3), 1);
end
unit_channel = find(area.channels.id == area.units.channels(unit));
lfp_channel = max(unit_channel - 10, 1);

timeseries = cat(1, area.(condition).lfp(lfp_channel, :, trials), ...
    area.(condition).unit_spikeseries(unit, :, trials));
ftdata = populate_ftdata(timeseries, [area.channels.id(lfp_channel); ...
    area.channels.id(unit_channel)], area.(condition).timestamps);
con = coherence(ftdata);
freqs = con.freq;
sfc = mean(squeeze(con.cohspctrm(1, :, :)), 1);
end
