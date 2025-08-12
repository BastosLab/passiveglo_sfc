function [con] = coherence(data)
cfg = [];
cfg.foi = 2:2:90;
cfg.method = 'mtmfft';
cfg.output = 'fourier';
cfg.pad = 'nextpow2';
cfg.taper = 'dpss';
cfg.tapsmofrq = 8;

ft = ft_freqanalysis(cfg, data);

cfg = [];
cfg.method = 'coh';
con = ft_connectivityanalysis(cfg, ft);
end

