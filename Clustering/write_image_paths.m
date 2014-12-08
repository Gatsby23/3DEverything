function write_image_paths

cls = 'table';
root_dir = '/home/yuxiang/Projects/3DEverything';

% load filenames
object = load(sprintf('filenames_%s.mat', cls));
filenames = object.filenames;
N = numel(filenames);

fid = fopen(sprintf('image_paths_%s.txt', cls), 'w');
for i = 1:N
    filename = fullfile(root_dir, sprintf('Images/%s/%s.JPG', cls, filenames{i}));
    fprintf(fid, '%s\n', filename);
end
fclose(fid);