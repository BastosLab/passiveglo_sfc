function [sessions] = area_coherences(area, contrasts, prestim, poststim)
session_dirs = dir('/mnt/data/000253/sub-*');
sessions = cell(size(session_dirs, 1), 1);
for s=1:size(session_dirs, 1)
    if ~session_dirs(s).isdir
        continue;
    end
    session = epoch_session_area(['/mnt/data/000253/', session_dirs(s).name], area, horzcat(contrasts{:})', prestim, poststim);
    session.coherences = {};
    for c=1:size(contrasts, 1)
        session.coherences{c} = units_coherence(session.(area), [ ...
            string(func2str(contrasts{c}{1})); string(func2str(contrasts{c}{2}))]);
    end
    sessions{s} = session;
end
end