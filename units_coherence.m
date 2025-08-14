function [coherences] = units_coherence(area, condl, condr)
coherences = [];
coherences.unit_ids = area.units.id(:);

avail_trials = min([size(area.(condl).lfp, 3), size(area.(condr).lfp, 3)]);
condl_trials = randi(size(area.(condl).lfp, 3), [avail_trials, 1]);
condr_trials = randi(size(area.(condr).lfp, 3), [avail_trials, 1]);

coherences.freqs = (2:2:90)';
coherences.sfc = [];
coherences.sfc.(condl) = nan(size(coherences.unit_ids, 1), size(coherences.freqs, 1));
coherences.sfc.(condr) = nan(size(coherences.unit_ids, 1), size(coherences.freqs, 1));
for u=1:size(coherences.unit_ids, 1)
    [coherences.freqs, sfc] = unit_coherence(area, u, condl, condl_trials);
    coherences.sfc.(condl)(u, :) = sfc;
    [coherences.freqs, sfc] = unit_coherence(area, u, condr, condr_trials);
    coherences.sfc.(condr)(u, :) = sfc;
end
end