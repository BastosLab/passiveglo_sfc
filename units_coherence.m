function [coherences] = units_coherence(area, conditions)
coherences = [];
coherences.unit_ids = area.units.id(:);
condition_trial_counts = nan(size(conditions));
for c=1:size(conditions, 1)
    condition_trial_counts(c) = size(area.(conditions(c)).lfp, 3);
end
avail_trials = min(condition_trial_counts);

coherences.freqs = (2:2:90)';
coherences.sfc = [];
for c=1:size(conditions, 1)
    cond = conditions(c);
    cond_trials = randi(size(area.(cond).lfp, 3), [avail_trials, 1]);
    coherences.sfc.(cond) = nan(size(coherences.unit_ids, 1), size(coherences.freqs, 1));
    for u=1:size(coherences.unit_ids, 1)
        [~, sfc] = unit_coherence(area, u, cond, cond_trials);
        coherences.sfc.(cond)(u, :) = sfc;
    end
end
end