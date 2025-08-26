function [unit_indices] = locate_units(sessions, area, conditions, locater)
names = fieldnames(sessions);
unit_indices = [];
for s=1:size(names, 1)
    session_unit_indices = locate_session_units(sessions.(names{s}).(area), ...
        conditions, locater);
    for c=1:size(conditions, 1)
        session = ones(size(session_unit_indices.(conditions{c}), 1), 1) * s;
        indices = cat(2, session, session_unit_indices.(conditions{c}));
        if s == 1
            unit_indices.(conditions{c}) = indices;
        else
            unit_indices.(conditions{c}) = cat(1, unit_indices.(conditions{c}), ...
                indices);
        end
    end
end
end

