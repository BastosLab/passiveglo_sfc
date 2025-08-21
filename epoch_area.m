function [sessions] = epoch_area(sessions_dir, area, interval_tags)
sessions = [];
session_dirs = dir([sessions_dir, '/sub-*']);
for s=1:size(session_dirs, 1)
    session_name = session_dirs(s).name;
    fieldname = matlab.lang.makeValidName(session_name);
    if isfolder([sessions_dir, '/', session_name])
        sessions.(fieldname) = epoch_session_area([sessions_dir, '/', session_name], ...
            area, interval_tags);
    end
end
end

