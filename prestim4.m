function [mask,prestim,poststim] = prestim4(passive_glo)
mask = passive_glo.presentation == 4;
prestim = 0.55;
poststim = -0.45;
end

