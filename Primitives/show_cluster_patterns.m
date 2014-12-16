function show_cluster_patterns(cid)

is_save = 0;

% load data
object = load('normal_patches.mat');
patches = object.patches;
object = load('idx.mat');
idx = object.idx;

% cluster centers
if nargin < 1
    centers = unique(idx);
    centers(centers == -1) = [];
else
    centers = cid;
end
N = numel(centers);

% hf = figure('units','normalized','outerposition',[0 0 0.5 1]);
hf = figure;
nplot = 8;
mplot = 8;
for i = 1:N
    disp(i);
    ind = centers(i);
    
    ind_plot = 1;
    % show center
    subplot(nplot, mplot, ind_plot);
    ind_plot = ind_plot + 1;
    filename = sprintf('training_images/%s/%s', patches(ind).cls, patches(ind).image);
    I = imread(filename);
    imshow(I);
    hold on;
    x1 = patches(ind).x1;
    y1 = patches(ind).y1;
    x2 = patches(ind).x2;
    y2 = patches(ind).y2;
    bbox = [x1 y1 x2-x1 y2-y1];
    rectangle('Position', bbox, 'EdgeColor', 'r', 'LineWidth', 2);
    hold off;
    
    % show several members
    member = find(idx == ind);
    member(member == ind) = [];
    num = numel(member);
    fprintf('%d examples\n', num+1);
    for j = 1:min(nplot*mplot-1, num)
        ind = member(j);
        subplot(nplot, mplot, ind_plot);
        ind_plot = ind_plot + 1;
        filename = sprintf('training_images/%s/%s', patches(ind).cls, patches(ind).image);
        I = imread(filename);
        imshow(I);
        hold on;
        x1 = patches(ind).x1;
        y1 = patches(ind).y1;
        x2 = patches(ind).x2;
        y2 = patches(ind).y2;
        bbox = [x1 y1 x2-x1 y2-y1];
        rectangle('Position', bbox, 'EdgeColor', 'r', 'LineWidth', 2);
        hold off;          
    end
    
    for j = ind_plot:nplot*mplot
        subplot(nplot, mplot, j);
        cla;
        title('');
    end
    if is_save
        filename = sprintf('Clusters/%03d.png', i);
        saveas(hf, filename);
    else
        pause;
    end
end