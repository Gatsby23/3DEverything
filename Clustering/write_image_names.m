function write_image_names

cls = 'table';
root_dir = '/home/yuxiang/Projects/3DEverything';

filename = sprintf('%s/Images/%s/*.JPG', root_dir, cls);
files = dir(filename);
N = numel(files);

filenames = cell(N, 1);
for i = 1:N
    pos = strfind(files(i).name, '.');
    filenames{i} = files(i).name(1:pos-1);
end

save(sprintf('filenames_%s.mat', cls), 'filenames');