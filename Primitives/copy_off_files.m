function copy_off_files

% read class names
fid = fopen('classes.txt', 'r');
C = textscan(fid, '%s');
classes = C{1};
fclose(fid);

N = numel(classes);
for i = 1:N
    cls = classes{i};
    out_dir = sprintf('CAD/%s', cls);
    if exist(out_dir', 'dir') == 0
        mkdir(out_dir);
    end
    
    command = sprintf('scp capri4:/scr/wonhui/projects/3dDataset/final_data/ImageNetCategories/CAD/%s/off_files_normalized/* %s', cls, out_dir);
    disp(command);
    unix(command);
end