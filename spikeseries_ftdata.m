function [ftdata] = spikeseries_ftdata(condition_data, unit_ids)

unit_ids = unit_ids(condition_data.accepted);
labels = cell(size(unit_ids, 1), 1);
for u=1:size(unit_ids, 1)
    labels{u} = ['Unit ', int2str(unit_ids(u))];
end
ftdata = populate_ftdata(condition_data.unit_spikeseries, string(labels), ...
    condition_data.timestamps);
ftdata = ft_checkdata(ftdata, 'datatype', 'spike', 'feedback', 'yes');
end

