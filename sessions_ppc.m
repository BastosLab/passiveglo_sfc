function [ppcs] = sessions_ppc(sessions, area, conditions, foi)
ppcs = [];
for c=1:size(conditions, 1)
    ppcs.(conditions{c}) = [];
    session_names = fieldnames(sessions);
    for s=1:size(session_names, 1)
        session = sessions.(session_names{s});
        sts = area_sts(session.(area), conditions{c}, foi);
        ppc = units_ppc(sts, sts.spike);
        unit_indices = cat(2, ones(size(ppc.ppc1, 1), 1) * s, ...
                session.(area).(conditions{c}).accepted);
        if s == 1
            ppcs.(conditions{c}).freqs = sts.freq';
            ppcs.(conditions{c}).ppc = ppc.ppc1;
            ppcs.(conditions{c}).num_spikes = ppc.num_spikes;
            ppcs.(conditions{c}).unit_indices = unit_indices;
        else
            ppcs.(conditions{c}).ppc = cat(1, ppcs.(conditions{c}).ppc, ...
                ppc.ppc1);
            ppcs.(conditions{c}).num_spikes = cat(1, ...
                ppcs.(conditions{c}).num_spikes, ppc.num_spikes);
            ppcs.(conditions{c}).unit_indices = cat(1, ...
                ppcs.(conditions{c}).unit_indices, unit_indices);
        end
    end
end
end

