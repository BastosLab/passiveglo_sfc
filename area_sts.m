function [sts] = area_sts(area, condition, foi)
unit_channel_ids = unique(area.units.channels);
unitfree_channels = true(size(area.channels.id));
for c=1:size(unitfree_channels, 1)
    if find(unit_channel_ids == area.channels.id(c))
        unitfree_channels(c) = false;
    end
end

T = squeeze(mean(area.(condition).timestamps(:, end, :) - area.(condition).timestamps(:, 1, :), 3));

lfp_channels = area.channels.id(unitfree_channels);
lfp = area.(condition).lfp(unitfree_channels, :, :);
ftlfp = populate_ftdata(lfp, lfp_channels, area.(condition).timestamps);
ftspikeseries = spikeseries_ftdata(area.(condition).unit_spikeseries, ...
    area.units.id, area.(condition).timestamps);

% Figure out the strongest channel
cfg = [];
cfg.method = 'mtmfft';
cfg.output = 'pow';
cfg.foi = foi;
cfg.pad = 'nextpow2';
cfg.taper = 'hann';
cfg.t_ftimwin = 5./cfg.foi;
cycles_mask = cfg.t_ftimwin <= T;
cfg.foi = cfg.foi(cycles_mask);
cfg.t_ftimwin = cfg.t_ftimwin(cycles_mask);

lfp_freqs = ft_freqanalysis(cfg, ftlfp);
[~, strongest_channel] = max(mean(lfp_freqs.powspctrm, 2));

ftlfp.label = {ftlfp.label{strongest_channel}};
for t=1:size(ftlfp.trial, 2)
    ftlfp.trial{:, t} = ftlfp.trial{:, t}(strongest_channel, :);
end

cfg = [];
cfg.foi = foi;
cfg.pad = 'nextpow2';
cfg.taper = 'hann';
cfg.t_ftimwin = 5./cfg.foi; % 5 cycles per frequency as per the paper
cycles_mask = cfg.t_ftimwin <= T;
cfg.foi = cfg.foi(cycles_mask);
cfg.t_ftimwin = cfg.t_ftimwin(cycles_mask);

sts = ft_spiketriggeredspectrum_convol(cfg, ftlfp, ftspikeseries);
sts.spike = ftspikeseries;
end

