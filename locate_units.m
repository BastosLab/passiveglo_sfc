function [unit_indices] = locate_units(area, conditions, locater)
located_units = locater(area.units.location);
unit_indices = [];
for c=1:size(conditions, 1)
    unit_indices.(conditions{c}) = intersect(find(located_units), area.(conditions{c}).accepted);
end
end

