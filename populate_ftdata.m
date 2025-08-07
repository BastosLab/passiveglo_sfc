function [data] = populate_ftdata(area, signals, channel_nums, timestamps)
assert(size(signals, 1) == size(channel_nums, 2));

data = [];
data.label = cell(size(channel_nums, 2), 1);
for c=1:size(channel_nums, 2)
    data.label{c} = [area, '_', int2str(channel_nums(c))];
end
data.time = cell(1, size(signals, 3));
data.trial = cell(1, size(signals, 3));
for tr=1:size(signals, 3)
    data.time{:, tr} = timestamps(:, :, tr);
    data.trial{:, tr} = signals(:, :, tr);
end
end
