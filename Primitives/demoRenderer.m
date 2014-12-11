function demoRenderer

% Add binary path
addpath('/home/yuxiang/Projects/3DEverything/Render');
addpath('/home/yuxiang/Projects/3DEverything/Render/bin');

% Initialize the Matlab object.
renderingSizeX = 400; renderingSizeY = 500; % pixels

azimuth = 45; elevation = 30; yaw = 0;
azimuth = 360 - azimuth;
% if you use field of view, set distance to 0
distance = 0; fieldOfView = 25; 


% Setup Renderer
renderer = Renderer();
if ~renderer.initialize({'CAD/chair/01.obj'}, ...
        renderingSizeX, renderingSizeY, 45, 0, 0, 0, 25)
    error('Renderer initilization failed');
end

% If you give the second output, it renders depth too.
renderer.setModelIndex(1);
renderer.setViewpoint(azimuth, elevation, yaw, distance, fieldOfView);

[rendering, depth]= renderer.render();
figure(1);
subplot(1,3,1);imagesc(rendering); axis equal; axis off;
subplot(1,3,2);imagesc(depth(end:-1:1,:)); axis equal; axis off; colormap hot;

P = renderer.getProjectionMatrix();
disp(P);
[Nx,Ny,Nz,valid] = computeNormals(depth(end:-1:1,:), P);
normalMap(:,:,1) = Nx;
normalMap(:,:,2) = Ny;
normalMap(:,:,3) = Nz;
normals = visualizeNormal(normalMap, valid);
subplot(1,3,3);imagesc(normals); axis equal; axis off;


% [X, Y, Z] = renderer.unprojDepth(depth);
% subplot(1,3,3); plot3(X(:), Y(:), Z(:), 'o'); axis equal;
% view(360 - azimuth, elevation);

% You must clear the memory before you exit
renderer.delete(); clear renderer;
