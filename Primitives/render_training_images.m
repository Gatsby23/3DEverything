function render_training_images

% add render path
addpath('/home/yuxiang/Projects/3DEverything/Render');
addpath('/home/yuxiang/Projects/3DEverything/Render/bin');

% rendering parameters
renderingSizeX = 224; 
renderingSizeY = 224;
azimuth = 0:15:345;
elevation = 0:15:90;
yaw = 0:30:330;
distance = 0;
fieldOfView = 25;
padding = 16;

% read class names
fid = fopen('classes.txt', 'r');
C = textscan(fid, '%s');
classes = C{1};
fclose(fid);

N = numel(classes);

% for each class
for c = 1:N
    cls = classes{c};
    files = dir(sprintf('CAD/%s/*.obj', cls));
    num = numel(files);
    
    % setup renderer
    renderer = Renderer();
    filenames = cell(1,num);
    for i = 1:num
        filenames{i} = sprintf('CAD/%s/%s', cls, files(i).name);
    end
    % initialize render
    if ~renderer.initialize(filenames, ...
            renderingSizeX, renderingSizeY, 45, 0, 0, 0, 25)
        error('Renderer initilization failed');
    end    
    
    % output dir
    outdir = sprintf('training_images/%s', cls);
    if exist(outdir, 'dir') == 0
        mkdir(outdir);
    end
    
    % for each CAD model
    for i = 1:num
        % render for each viewpoint
        for a = azimuth
            for e = elevation
                for y = yaw
                    % rendering
                    renderer.setModelIndex(i);
                    renderer.setViewpoint(360 - a, e, y, distance, fieldOfView);
                    [rendering, depth]= renderer.render();
                    rendering = padarray(rendering, [padding padding 0], 255);
                    depth = padarray(depth, [padding padding 0], 1);
                    depth = 1 - depth;

                    % compute depth image
                    depths = uint8(255*depth(end:-1:1,:));

                    % compute normals
                    P = renderer.getProjectionMatrix();
                    P(1,3) = P(1,3) - padding;
                    P(2,3) = P(2,3) - padding;
                    [Nx, Ny, Nz, Xd, Yd, Zd, valid] = computeNormals(depth(end:-1:1,:), P);
                    normalMap(:,:,1) = Nx;
                    normalMap(:,:,2) = Ny;
                    normalMap(:,:,3) = Nz;
                    normals = visualizeNormal(normalMap, valid);

                    % compute gray image from normals
                    gray = rgb2gray(normals);

                    % save gray image
                    filename = sprintf('%s/cad%02d_a%03d_e%02d_y%03d_image.jpg', outdir, i, a, e, y);
                    fprintf('%s\n', filename);
                    imwrite(gray, filename);

                    % save depth image
                    filename = sprintf('%s/cad%02d_a%03d_e%02d_y%03d_depth.jpg', outdir, i, a, e, y);
                    fprintf('%s\n', filename);
                    imwrite(depths, filename);

                    % save normal image
%                     filename = sprintf('%s/cad%02d_a%03d_e%02d_normal.jpg', outdir, i, a, e);
%                     fprintf('%s\n', filename);
%                     imwrite(normals, filename);
                end
            end
        end
    end
    renderer.delete();
    clear renderer;
end