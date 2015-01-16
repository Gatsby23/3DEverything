function demoRenderer

% Add binary path
addpath('/home/yuxiang/Projects/3DEverything/Render');
addpath('/home/yuxiang/Projects/3DEverything/Render/bin');

% Initialize the Matlab object.
% if you use field of view, set distance to 0
renderingSizeX = 224; renderingSizeY = 224; % pixels
elevation = 90; yaw = 0;
distance = 0; fieldOfView = 25;

cls = 'chair';
files = dir(sprintf('CAD/%s/*.obj', cls));
N = numel(files);

for i = 1:N
    filename = sprintf('CAD/%s/%02d.obj', cls, i);
    % Setup Renderer
    renderer = Renderer();
    if ~renderer.initialize({filename}, ...
            renderingSizeX, renderingSizeY, 45, 0, 0, 0, 25)
        error('Renderer initilization failed');
    end

    mplot = 8;
    nplot = 6;
    index_plot = 1;
    for azimuth = 0:15:345
        % If you give the second output, it renders depth too.
        renderer.setModelIndex(1);
        renderer.setViewpoint(360 - azimuth, elevation, yaw, distance, fieldOfView);
        [rendering, depth]= renderer.render();

    %     subplot(mplot, nplot, index_plot);
    %     index_plot = index_plot + 1;
    %     imagesc(depth(end:-1:1,:));
    %     axis equal;
    %     axis off;
    %     colormap hot;

        P = renderer.getProjectionMatrix();       
        [Nx,Ny,Nz,Xd, Yd, Zd, valid] = computeNormals(depth(end:-1:1,:), P);
        normalMap(:,:,1) = Nx;
        normalMap(:,:,2) = Ny;
        normalMap(:,:,3) = Nz;
        normals = visualizeNormal(normalMap, valid);
        
        % compute gray image from normals
        gray = rgb2gray(normals);
        I = repmat(gray, [1 1 3]);
        
        subplot(mplot, nplot, index_plot);
        index_plot = index_plot + 1;
        imagesc(I);
        axis equal;
        axis off;        

        subplot(mplot, nplot, index_plot);
        index_plot = index_plot + 1;
        imagesc(normals);
        axis equal;
        axis off;
    end
    
    pause;
end


% [X, Y, Z] = renderer.unprojDepth(depth);
% subplot(1,3,3); plot3(X(:), Y(:), Z(:), 'o'); axis equal;
% view(360 - azimuth, elevation);

% You must clear the memory before you exit
renderer.delete(); clear renderer;