function display_off_file_all

is_save = 1;

% read class names
fid = fopen('classes.txt', 'r');
C = textscan(fid, '%s');
classes = C{1};
fclose(fid);

N = numel(classes);
mplot = 6;
nplot = 6;
h = figure;
for i = 1:N
    cls = classes{i};
    disp(cls);    
    files = dir(sprintf('CAD/%s/*.off', cls));
    for j = 1:numel(files)
        filename = sprintf('CAD/%s/%s', cls, files(j).name);
        [vertices, faces] = load_off_file(filename);
        subplot(mplot, nplot, j);
        trimesh(faces, vertices(:,1), vertices(:,2), vertices(:,3), 'EdgeColor', 'b');
        view(330, 30);
        axis equal;
        axis tight;
        axis off;
%         xlabel('x');
%         ylabel('y');
%         zlabel('z');
        title(cls);
    end
    for j = numel(files)+1:mplot*nplot
        subplot(mplot, nplot, j);
        cla;
        axis off;
        title('');
    end
    if is_save == 0
        pause;
    else
        filename = sprintf('CAD_images/%s.png', cls);
        saveas(h, filename);
    end
end