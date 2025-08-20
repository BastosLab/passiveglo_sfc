function [stas] = area_sta(area, condition, foi)
unit_channel_ids = unique(area.units.channels);
unitfree_channels = true(size(area.channels.id));
for c=1:size(unitfree_channels, 1)
    if find(unit_channel_ids == area.channels.id(c))
        unitfree_channels(c) = false;
    end
end

T = squeeze(mean(area.(condition).timestamps(:, end, :) - area.(condition).timestamps(:, 1, :), 3));

lfp_local_indices = 1:size(area.channels.id, 1);
lfp_local_indices = lfp_local_indices(unitfree_channels);
lfp_channels = area.channels.id(unitfree_channels);
lfp = area.(condition).lfp(unitfree_channels, :, :);
ftlfp = populate_ftdata(lfp, lfp_channels, area.(condition).timestamps);

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
lfp_local_index = lfp_local_indices(strongest_channel);

accepted_unit_ids = area.units.id(area.(condition).units_accepted);
stas = cell(size(accepted_unit_ids, 1), 1);
for au=1:size(accepted_unit_ids, 1)
    stas{au} = unit_sta(area, condition, lfp_local_index, accepted_unit_ids(au), foi);
end
end

