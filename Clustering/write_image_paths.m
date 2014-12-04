function write_image_paths

cls = 'chair';
root_dir = '/home/yuxiang/Projects/3DEverything';

% load filenames
object = load('sift_features/filenames.mat');
filenames = object.filenames;
N = numel(filenames);

fid = fopen('image_paths.txt', 'w');
for i = 1:N
    filename = fullfile(root_dir, sprintf('Images/%s/%s.JPG', cls, filenames{i}));
    fprintf(fid, '%s\n', filename);
end
fclose(fid);