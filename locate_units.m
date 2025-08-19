function [unit_indices] = locate_units(area, conditions, locater)
located_units = locater(session.VISp.units.location);
unit_indices = [];
for c=1:size(conditions, 1)
    accepted_units = find(area.(conditions(c)));
    accepted_location_units = find(area.(conditions(c)).units_accepted & located_units);
    [~, indices] = ismember(accepted_location_units, accepted_units);
    unit_indices.(conditions(c)) = indices;
end
end

