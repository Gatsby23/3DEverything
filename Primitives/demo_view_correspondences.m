function demo_view_correspondences

% Add binary path
addpath('/home/yuxiang/Projects/3DEverything/Render');
addpath('/home/yuxiang/Projects/3DEverything/Render/bin');

% Initialize the Matlab object.
% if you use field of view, set distance to 0
renderingSizeX = 400; renderingSizeY = 400; % pixels
elevation = 15; yaw = 0;
distance = 0; fieldOfView = 25;

cls = 'chair';
cad_index = 1;
filename = sprintf('CAD/%s/%02d.obj', cls, cad_index);
% Setup Renderer
renderer = Renderer();
if ~renderer.initialize({filename}, ...
        renderingSizeX, renderingSizeY, 45, 0, 0, 0, 25)
    error('Renderer initilization failed');
end

% two azimuths
azimuth1 = 15;
azimuth2 = -15;

% render azimuth1
renderer.setModelIndex(1);
renderer.setViewpoint(360 - azimuth1, elevation, yaw, distance, fieldOfView);
[rendering, depth]= renderer.render();

% compute the normal image
P = renderer.getProjectionMatrix();       
[Nx,Ny,Nz,Xd, Yd, Zd, valid] = computeNormals(depth(end:-1:1,:), P);
normalMap(:,:,1) = Nx;
normalMap(:,:,2) = Ny;
normalMap(:,:,3) = Nz;
normals = visualizeNormal(normalMap, valid);

% compute gray image from normals
gray = rgb2gray(normals);
I = repmat(gray, [1 1 3]);

% show the rendering
subplot(2, 2, 1);
imagesc(I);
axis equal;

% backproject to 3D
[X, Y, Z] = renderer.unprojDepth(depth);
subplot(2,2,2); 
plot3(X(:), Y(:), Z(:), 'o');
axis equal;
view(azimuth1, elevation);

% render azimuth2
renderer.setViewpoint(360 - azimuth2, elevation, yaw, distance, fieldOfView);
[rendering2, depth2]= renderer.render();

% compute the normal image
P2 = renderer.getProjectionMatrix();
R2 = renderer.getViewMatrix();
[Nx,Ny,Nz,Xd, Yd, Zd, valid] = computeNormals(depth2(end:-1:1,:), P2);
normalMap(:,:,1) = Nx;
normalMap(:,:,2) = Ny;
normalMap(:,:,3) = Nz;
normals = visualizeNormal(normalMap, valid);

% compute gray image from normals
gray = rgb2gray(normals);
I2 = repmat(gray, [1 1 3]);

% show the rendering
subplot(2, 2, 3);
imagesc(I2);
axis equal;

% find the correspondences
width = size(I, 2);
height = size(I, 1);
CorrX = zeros(height, width);
CorrY = zeros(height, width);
for x = 1:width
    for y = 1:height
        if depth(y,x) > 0 && depth(y,x) < 1
            % find the 3D point
            p3d = [X(y,x); Y(y,x); Z(y,x); 1];
            % projection
            p2d = P2 * R2 * p3d;
            p2d = p2d ./ p2d(4);
            
            % skip self-occluded points
            if p2d(3) > depth2(round(p2d(2)), round(p2d(1))) + 0.001
                continue;
            end
            
            % corresponding points
            loc1 = [x height-y];
            loc2 = [p2d(1) height-p2d(2)];
            
            % save correspondences
            CorrX(loc1(2), loc1(1)) = loc2(1);
            CorrY(loc1(2), loc1(1)) = loc2(2);
            
            % show the match
            I3 = appendimages(I,I2);
            subplot(2,2,4);
            imshow(I3);
            hold on;
            plot(loc1(1), loc1(2), 'ro');
            plot(loc2(1)+width, loc2(2), 'ro');
            line([loc1(1) loc2(1)+width], [loc1(2) loc2(2)], 'Color', 'c');
            hold off;
            pause;
        end
    end
end

% You must clear the memory before you exit
renderer.delete(); 
clear renderer;