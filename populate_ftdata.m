function [data] = populate_ftdata(signals, channels, timestamps)
assert(size(signals, 1) == size(channels, 1));

data = [];
data.label = cell(size(channels, 1), 1);
for c=1:size(channels, 1)
    data.label{c} = char(string(channels(c)));
end
data.time = cell(1, size(signals, 3));
data.trial = cell(1, size(signals, 3));
for tr=1:size(signals, 3)
    data.time{:, tr} = timestamps(:, :, tr);
    data.trial{:, tr} = signals(:, :, tr);
end
data.fsample = round(1 / mean(diff(timestamps, 1, 2), [2, 3]));
data = ft_checkdata(data, 'datatype', 'raw', 'feedback', 'yes');
end
