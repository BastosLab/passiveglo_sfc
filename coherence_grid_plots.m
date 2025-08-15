function [] = coherence_grid_plots(coherences, condl, condr, area, nwb)
num_grids = idivide(int64(size(coherences.unit_ids, 1)), int64(20), 'ceil');
for g=1:num_grids
    figure; t = tiledlayout(5, 4);
    title(t, string(nwb), 'Interpreter', 'none');

    for u=(g-1)*20+1:g*20
        location = area.channels.location(area.channels.id == area.units.channels(u));

        nexttile;
        plot(coherences.freqs, squeeze(coherences.sfc.(condl)(u, :)), 'r', ...
             coherences.freqs, squeeze(coherences.sfc.(condr)(u, :)), 'b');
        xlabel("Frequency (Hz)"); ylabel("Coherence (0-1)");
        xlim([0, 90]); ylim([0.5, 0.575]);
        title(['Unit ', int2str(coherences.unit_ids(u)), ' (', location{1}, ')']);
    end
    leg = legend({strrep(condl, '_', '\_'); strrep(condr, '_', '\_')});
    leg.Layout.Tile = 'East';
end
end

