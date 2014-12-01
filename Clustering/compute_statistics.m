function compute_statistics

cls = 'chair';
filename = sprintf('../Images/%s/*.JPG', cls);
files = dir(filename);
N = numel(files);

filenames = cell(N, 1);
for i = 1:N
    filename = files(i).name;
    pos = strfind(filename, '_');
    filenames{i} = filename(1:pos-1);
end

items = unique(filenames);
M = numel(items);
item_count = zeros(M, 1);
for i = 1:M
    item_count(i) = sum(strcmp(items{i}, filenames));
end

fprintf('%d images for %s\n', N, cls);
fprintf('%d items for %s\n', M, cls);
fprintf('%.2f images per item for %s\n', mean(item_count), cls);