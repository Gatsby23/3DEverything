function process_images

cls = 'chair';
root_dir = '/home/yuxiang/Projects/3DEverything';
filename = sprintf('%s/Images/%s/*.JPG', root_dir, cls);
files = dir(filename);
N = numel(files);
threshold = 400;

for i = 1:N
    filename = sprintf('%s/Images/%s/%s', root_dir, cls, files(i).name);
    try
        I = imread(filename);
    catch
        fprintf('%d/%d: %s\n', i, N, filename);
        continue;
    end
    h = size(I,1);
    w = size(I,2);
    
    if max(h, w) > threshold
        scale = threshold / max(h, w);
        I = imresize(I, scale);
        imwrite(I, filename, 'jpg');
    end
end