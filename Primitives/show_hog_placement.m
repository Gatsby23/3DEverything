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
pnum = 32;
threshold = 0.5;
padding = 16;

cls = 'car';
index = 2;

filename = sprintf('CAD/%s/%02d.obj', cls, index);
% Setup Renderer
renderer = Renderer();
if ~renderer.initialize({filename}, ...
        renderingSizeX, renderingSizeY, 45, 0, 0, 0, 25)
    error('Renderer initilization failed');
end

mplot = 2;
nplot = 2;
index_plot = 1;
for azimuth = 0:15:345
    % rendering
    renderer.setModelIndex(1);
    renderer.setViewpoint(360 - azimuth, elevation, yaw, distance, fieldOfView);
    [rendering, depth]= renderer.render();
    rendering = padarray(rendering, [padding padding 0], 255);
    depth = padarray(depth, [padding padding 0], 1);
    
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
    
    num = sum(sum(valid));
    pointMap = [];
    pointMap(:,1) = reshape(Xd(valid), num, 1);
    pointMap(:,2) = reshape(Yd(valid), num, 1);
    pointMap(:,3) = reshape(Zd(valid), num, 1);
    
    % compute HOG
    I = repmat(gray, [1 1 3]);
    f = features(double(I), sbin);
    % compute HOG placement
    pfilters = mkpartfilters(f(:,:,19:27), psize, pnum);
    % sort the placement
    energy = zeros(pnum, 1);
    for i = 1:pnum
        energy(i) = pfilters(i).energy;
    end
    [~, index] = sort(energy, 'descend');
    pfilters = pfilters(index);    

    % show rendering image
    subplot(mplot, nplot, index_plot);
    index_plot = index_plot + 1;
    imagesc(gray);
    axis equal;
    axis off;
    hold on;
    % show HOG and placement
%     for i = 1:pnum
%         if pfilters(i).energy < threshold
%             break;
%         end
%         anchor = pfilters(i).anchor;
%         x = (anchor(1)+2) * sbin + sbin/2;
%         y = (anchor(2)+2) * sbin + sbin/2;
%         plot(x, y, 'bo', 'LineWidth', 2);
%         w = psize(1)*sbin;
%         h = psize(2)*sbin;
%         bbox = [x-w/2 y-h/2 w h];
%         rectangle('Position', bbox, 'EdgeColor', 'r', 'LineWidth', 2);
%         % text(bbox(1), bbox(2), num2str(i), 'BackgroundColor',[.7 .9 .7]);
%     end
%     hold off;
    
    % plot normals
    subplot(mplot, nplot, index_plot);
    index_plot = index_plot + 1;
    imagesc(normals);
    hold on;
    for i = 1:pnum
        if pfilters(i).energy < threshold
            break;
        end        
        anchor = pfilters(i).anchor;
        x = (anchor(1)+2) * sbin + sbin/2;
        y = (anchor(2)+2) * sbin + sbin/2;
        plot(x, y, 'bo', 'LineWidth', 2);
        w = psize(1)*sbin;
        h = psize(2)*sbin;
        bbox = [x-w/2 y-h/2 w h];
        rectangle('Position', bbox, 'EdgeColor', 'r', 'LineWidth', 2);
    end
    hold off;
    axis equal;
    axis off;
    
    % plot 3D points
    subplot(mplot, nplot, index_plot);
    index_plot = index_plot + 1;
    plot3(pointMap(:,1), pointMap(:,2), pointMap(:,3), 'o');
    axis equal;
    xlabel('x');
    ylabel('y');
    zlabel('z');
    view(0, -90);
    
    % Normal vector points
    xc = pointMap(:,1);
    yc = pointMap(:,2);
    zc = pointMap(:,3);
    nx = reshape(Nx(valid), num, 1);
    ny = reshape(Ny(valid), num, 1);
    nz = reshape(Nz(valid), num, 1);
    Sx = 0.1;
    Sy = 0.1;
    Sz = 0.1;
   
    hold on;
    % use nan trick here
    xp = [xc(:) Sx*nx(:)+xc(:) repmat(nan,[numel(xc) 1])]';
    yp = [yc(:) Sy*ny(:)+yc(:) repmat(nan,[numel(xc) 1])]';
    zp = [zc(:) Sz*nz(:)+zc(:) repmat(nan,[numel(xc) 1])]';
   
    plot3(xp(:), yp(:), zp(:), 'r-');
    hold off;
    
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