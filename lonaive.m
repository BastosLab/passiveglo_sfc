function [mask] = lonaive(passive_glo)
mask = passive_glo.lo_gloexp;
entries = find(mask);
mask(entries(51:end)) = 0;
end
