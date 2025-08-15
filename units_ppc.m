function [stats] = units_ppc(sts, ft_spikeseries)
num_units = length(ft_spikeseries.label);

stats = [];
stats.ppc1 = nan(num_units, length(sts.lfplabel), length(sts.freq));
stats.num_spikes = nan(num_units, length(sts.freq));
for u=1:num_units
    if length(sts.time{u}) < 3
        continue
    end

    cfg = [];
    cfg.spikechannel = u;
    cfg.method = 'ppc1';
    stat_ppc = ft_spiketriggeredspectrum_stat(cfg, sts);
    stats.ppc1(u, :, :) = stat_ppc.ppc1;
    stats.num_spikes(u, :) = mean(stat_ppc.nspikes, 1);
end
end

