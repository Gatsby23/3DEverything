function convert_off2obj

file_off = 'CAD/chair/01.off';
file_obj = 'CAD/chair/01';

[vertices, faces] = load_off_file(file_off);
vertices = [vertices(:,1) vertices(:,3) -vertices(:,2)];
write_off_file(vertices, faces, 'tmp.off');

command = sprintf('./meshconv tmp.off -c obj -o %s', file_obj);
unix(command);
unix('rm tmp.off');