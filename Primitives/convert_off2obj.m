function convert_off2obj

cls = 'car';
N = 1;

for i = 1:N
    file_off = sprintf('CAD/%s/%02d.off', cls, i);
    file_obj = sprintf('CAD/%s/%02d', cls, i);

    [vertices, faces] = load_off_file(file_off);
    vertices = [vertices(:,1) vertices(:,3) -vertices(:,2)];
    write_off_file(vertices, faces, 'tmp.off');

    command = sprintf('./meshconv tmp.off -c obj -o %s', file_obj);
    unix(command);
    unix('rm tmp.off');
end