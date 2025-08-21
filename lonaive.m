function [mask,prestim,poststim] = lonaive(passive_glo)
mask = passive_glo.lo_gloexp;
entries = find(mask);
mask(entries(51:end)) = 0;
prestim = 0.05;
poststim = 0.05;
end
