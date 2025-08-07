function [con] = coherence(data)
cfg = [];
cfg.method = 'mtmfft';
cfg.taper = 'dpss';
cfg.foilim = [2 90];
cfg.tapsmofrq = 8;
cfg.output = 'fourier';
ft = ft_freqanalysis(cfg, data);

cfg = [];
cfg.method = 'coh';
con = ft_connectivityanalysis(cfg, ft);
end

