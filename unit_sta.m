function [sta] = unit_sta(area, condition, channel, unit, foi)

au = find(area.units.id(area.(condition).units_accepted) == unit);
timeseries = cat(1, area.(condition).lfp(channel, :, :), ...
    area.(condition).unit_spikeseries(au, :, :));
ftdata = populate_ftdata(timeseries, [area.channels.id(channel); ...
    unit], area.(condition).timestamps);

cfg = [];
cfg.channel = ftdata.label{1};
cfg.spikechannel = ftdata.label{2};
cfg.timwin = [-2.5 / mean(foi), 2.5 / mean(foi)];
sta = ft_spiketriggeredaverage(cfg, ftdata);
end

