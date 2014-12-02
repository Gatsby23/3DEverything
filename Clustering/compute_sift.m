function compute_sift

cls = 'chair';
root_dir = '/home/yuxiang/Projects/3DEverything';
filename = sprintf('%s/Images/%s/*.JPG', root_dir, cls);
files = dir(filename);
N = numel(files);
filenames = cell(N, 1);

for i = 1:N
    filename = sprintf('%s/Images/%s/%s', root_dir, cls, files(i).name);
    fprintf('%d/%d: %s\n', i, N, filename);
    [image, descriptors, locs] = sift(filename);
    
    pos = strfind(files(i).name, '.');
    filenames{i} = files(i).name(1:pos-1);
    matfile = ['sift_features/' files(i).name(1:pos) 'mat'];
    save(matfile, 'descriptors', 'locs');
end

save('sift_features/filenames.mat', 'filenames');