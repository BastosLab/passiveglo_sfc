function [mask,prestim,poststim] = go_seq(passive_glo)
mask = passive_glo.go_seq & (passive_glo.presentation == 4);
prestim = 0.05;
poststim = 0.05;
end