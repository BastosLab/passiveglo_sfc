function [sts] = area_sts(area, condition)
unit_channel_ids = unique(area.units.channels);
unitfree_channels = true(size(area.channels.id));
for c=1:size(unitfree_channels, 1)
    if find(unit_channel_ids == area.channels.id(c))
        unitfree_channels(c) = false;
    end
end

lfp_channels = area.channels.id(unitfree_channels);
lfp = area.(condition).lfp(unitfree_channels, :, :);
ftlfp = populate_ftdata(lfp, lfp_channels, area.(condition).timestamps);
ftspikeseries = spikeseries_ftdata(area.(condition).unit_spikeseries, ...
    area.units.id, area.(condition).timestamps);

cfg = [];
cfg.foi = 10:90;
cfg.taper = 'hann';
cfg.t_ftimwin = 9./cfg.foi; % 9 cycles per frequency as per the paper

sts = ft_spiketriggeredspectrum_convol(cfg, ftlfp, ftspikeseries);
end

