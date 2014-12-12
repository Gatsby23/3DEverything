function show_hog_placement

% Add binary path
addpath('/home/yuxiang/Projects/3DEverything/Render');
addpath('/home/yuxiang/Projects/3DEverything/Render/bin');

% Initialize the Matlab object.
% if you use field of view, set distance to 0
renderingSizeX = 400; renderingSizeY = 400; % pixels
elevation = 15; yaw = 0;
distance = 0; fieldOfView = 25;
sbin = 8;
psize = [4 4];
pnum = 16;

cls = 'chair';
index = 2;

filename = sprintf('CAD/%s/%02d.obj', cls, index);
% Setup Renderer
renderer = Renderer();
if ~renderer.initialize({filename}, ...
        renderingSizeX, renderingSizeY, 45, 0, 0, 0, 25)
    error('Renderer initilization failed');
end

mplot = 1;
nplot = 3;
index_plot = 1;
for azimuth = 0:15:345
    % If you give the second output, it renders depth too.
    renderer.setModelIndex(1);
    renderer.setViewpoint(360 - azimuth, elevation, yaw, distance, fieldOfView);
    [rendering, depth]= renderer.render();

    subplot(mplot, nplot, index_plot);
    index_plot = index_plot + 1;
    imagesc(rendering);
    axis equal;
    axis off;

    P = renderer.getProjectionMatrix();
    [Nx,Ny,Nz,valid] = computeNormals(depth(end:-1:1,:), P);
    normalMap(:,:,1) = Nx;
    normalMap(:,:,2) = Ny;
    normalMap(:,:,3) = Nz;
    normals = visualizeNormal(normalMap, valid);
    
    % compute HOG
    f = features(double(normals), sbin);    
    % compute HOG placement
    pfilters = mkpartfilters(f, psize, pnum);
    
    % plot normals
    subplot(mplot, nplot, index_plot);
    index_plot = index_plot + 1;
    imagesc(normals);
    hold on;
    
    for i = 1:pnum
        anchor = pfilters(i).anchor;
        x = (anchor(1)+2) * sbin + sbin/2;
        y = (anchor(2)+2) * sbin + sbin/2;
        plot(x, y, 'bo', 'LineWidth', 4);
        w = psize(1)*sbin;
        h = psize(2)*sbin;
        bbox = [x-w/2 y-h/2 w h];
        rectangle('Position', bbox, 'EdgeColor', 'r', 'LineWidth', 2);
    end
    
    hold off;
    axis equal;
    axis off;
    
    % plot HOG
    subplot(mplot, nplot, index_plot);
    index_plot = index_plot + 1;
    visualizeHOG(f);
    
    if index_plot > mplot * nplot
        index_plot = 1;
        pause;
    end
end

% You must clear the memory before you exit
renderer.delete(); clear renderer;