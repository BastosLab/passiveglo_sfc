function [freqs, sfc] = unit_coherence(area, unit, condition)
unit_channel = find(area.channels.id == area.units.channels(unit));
lfp_channel = max(unit_channel - 10, 1);

timeseries = cat(1, area.(condition).lfp(lfp_channel, :, :), ...
    area.units.unit_spikeseries(unit, :, :));
ftdata = populate_ftdata(timeseries, [area.channels.id(lfp_channel); ...
    area.channels.id(unit_channel)], area.(condition).timestamps);
con = coherence(ftdata);
freqs = con.freq;
sfc = mean(squeeze(con.cohspctrm(1, :, :)), 1);
end

