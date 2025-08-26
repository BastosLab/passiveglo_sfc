function [mask] = infragranular(locations)
mask = contains(locations, "5") | contains(locations, "6");
end

