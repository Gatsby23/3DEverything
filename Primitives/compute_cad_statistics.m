function compute_cad_statistics

% read class names
fid = fopen('classes.txt', 'r');
C = textscan(fid, '%s');
classes = C{1};
fclose(fid);

N = numel(classes);
count = 0;
for i = 1:N
    cls = classes{i};
    files = dir(sprintf('CAD/%s/*.obj', cls));
    count = count + numel(files);
end

fprintf('%d CAD models in total\n', count);