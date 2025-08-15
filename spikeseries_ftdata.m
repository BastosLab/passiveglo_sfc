function [ftdata] = spikeseries_ftdata(spikeseries, unit_ids, timestamps)
assert(size(spikeseries, 1) == size(unit_ids, 1));
labels = cell(size(unit_ids, 1), 1);
for u=1:size(unit_ids, 1)
    labels{u} = ['Unit ', int2str(unit_ids(u))];
end
ftdata = populate_ftdata(spikeseries, string(labels), timestamps);
ftdata = ft_checkdata(ftdata, 'datatype', 'spike', 'feedback', 'yes');
end

