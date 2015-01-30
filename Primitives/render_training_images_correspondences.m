function render_training_images_correspondences

% add render path
addpath('/home/yuxiang/Projects/3DEverything/Render');
addpath('/home/yuxiang/Projects/3DEverything/Render/bin');

% rendering parameters
renderingSizeX = 227; 
renderingSizeY = 227;
azimuth = 0:5:355;
elevation = 0:15:45;
yaw = 0;
distance = 0;
fieldOfView = 25;

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
    outdir = sprintf('training_mats_correspondences/%s', cls);
    if exist(outdir, 'dir') == 0
        mkdir(outdir);
    end
    
    outdir_cor = sprintf('labels_correspondences/%s', cls);
    if exist(outdir_cor, 'dir') == 0
        mkdir(outdir_cor);
    end
    num_label = 0;
    
    % for each CAD model
    for i = 1:num
        % store the rendering information
        objects = [];
        count = 0;
        % render for each viewpoint
        for a = azimuth
            for e = elevation
                for y = yaw
                    % rendering
                    renderer.setModelIndex(i);
                    renderer.setViewpoint(360 - a, e, y, distance, fieldOfView);
                    [rendering, depth]= renderer.render();

                    % compute normals
                    P = renderer.getProjectionMatrix();
                    R = renderer.getViewMatrix();
                    [Nx, Ny, Nz, Xd, Yd, Zd, valid] = computeNormals(depth(end:-1:1,:), P);
                    normalMap(:,:,1) = Nx;
                    normalMap(:,:,2) = Ny;
                    normalMap(:,:,3) = Nz;
                    normals = visualizeNormal(normalMap, valid);

                    % compute gray image from normals
                    gray = rgb2gray(normals);
                    mask = gray > 0;
                    
                    filename = sprintf('%s/cad%02d_a%03d_e%02d_y%03d_image.mat', outdir, i, a, e, y);
                    fprintf('%s\n', filename);
                    save(filename, 'gray', 'mask');
                    
%                     % backproject to 3D
%                     [X, Y, Z] = renderer.unprojDepth(depth);                    
% 
%                     % save gray image
%                     filename = sprintf('%s/cad%02d_a%03d_e%02d_y%03d_image.jpg', outdir, i, a, e, y);
%                     fprintf('%s\n', filename);
%                     imwrite(gray, filename);
% 
%                     % build the object structure
%                     count = count + 1;
%                     objects(count).filename = filename;
%                     objects(count).azimuth = a;
%                     objects(count).elevation = e;
%                     objects(count).yaw = y;
%                     objects(count).image = gray;
%                     objects(count).depth = depth;
%                     objects(count).P = P;
%                     objects(count).R = R;
%                     objects(count).X = X;
%                     objects(count).Y = Y;
%                     objects(count).Z = Z;
                end
            end
        end
        
%         % find the correspondences
%         for j = 1:count
%             for k = 1:count
%                 % only consider the same elevation for now
%                 if j == k || objects(j).elevation ~= objects(k).elevation
%                     continue;
%                 end
%                 azimuth1 = objects(j).azimuth;
%                 azimuth2 = objects(k).azimuth;
%                 amax = max(azimuth1, azimuth2);
%                 amin = min(azimuth1, azimuth2);
%                 diff = min(amax - amin, 360 - amax + amin);
%                 % only consider azimuth difference < 30
%                 if diff > 30
%                     continue;
%                 end
%                 
%                 % compute the correspondences
%                 I = objects(j).image;
%                 depth = objects(j).depth;
%                 X = objects(j).X;
%                 Y = objects(j).Y;
%                 Z = objects(j).Z;
%                 
%                 P2 = objects(k).P;
%                 R2 = objects(k).R;
%                 depth2 = objects(k).depth;
%                 
%                 width = size(I, 2);
%                 height = size(I, 1);
%                 CorrX = zeros(height, width);
%                 CorrY = zeros(height, width);
%                 for x = 1:width
%                     for y = 1:height
%                         if depth(y,x) > 0 && depth(y,x) < 1
%                             % find the 3D point
%                             p3d = [X(y,x); Y(y,x); Z(y,x); 1];
%                             % projection
%                             p2d = P2 * R2 * p3d;
%                             p2d = p2d ./ p2d(4);
% 
%                             % skip self-occluded points
%                             if round(p2d(1)) < 1 || round(p2d(1)) > renderingSizeX || ...
%                                     round(p2d(2)) < 1 || round(p2d(2)) > renderingSizeY || ...
%                                     p2d(3) > depth2(round(p2d(2)), round(p2d(1))) + 0.1
%                                 continue;
%                             end
% 
%                             % corresponding points
%                             loc1 = [x height-y+1];
%                             loc2 = [p2d(1) height-p2d(2)+1];
% 
%                             % save correspondences
%                             CorrX(loc1(2), loc1(1)) = loc2(1);
%                             CorrY(loc1(2), loc1(1)) = loc2(2);
%                         end
%                     end
%                 end                
%                 
%                 % save the correspondences
%                 cor.image_left = objects(j).filename;
%                 cor.image_right = objects(k).filename;
%                 cor.corX = CorrX;
%                 cor.corY = CorrY;
%                 num_label = num_label + 1;
%                 filename = sprintf('%s/%06d.mat', outdir_cor, num_label);
%                 disp(filename);
%                 save(filename, 'cor');
%             end
%         end
    end
    renderer.delete();
    clear renderer;
end