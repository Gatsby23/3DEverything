function convert_off2obj

% read class names
fid = fopen('classes.txt', 'r');
C = textscan(fid, '%s');
classes = C{1};
fclose(fid);

N = numel(classes);
for i = 1:N
    cls = classes{i};
    disp(cls);
    files = dir(sprintf('CAD/%s/*.off', cls));
    
    for j = 1:numel(files)
        file_off = sprintf('CAD/%s/%s', cls, files(j).name);
        
        pos = strfind(files(j).name, '.');
        file_obj = sprintf('CAD/%s/%s', cls, files(j).name(1:pos-1));

        [vertices, faces] = load_off_file(file_off);
        vertices = [vertices(:,1) vertices(:,3) -vertices(:,2)];
        write_off_file(vertices, faces, 'tmp.off');

        command = sprintf('./meshconv tmp.off -c obj -o %s', file_obj);
        unix(command);
        unix('rm tmp.off');
    end
    
end