function show_cluster_patterns

cls = 'chair';
is_save = 0;

% load filenames
object = load('sift_features/filenames.mat');
filenames = object.filenames;

% load idx
object = load('idx_ap.mat');
idx = object.idx_ap;

% cluster centers
centers = unique(idx);
N = numel(centers);
fprintf('Number of clusters: %d\n', N);

% hf = figure('units','normalized','outerposition',[0 0 0.5 1]);
hf = figure;
nplot = 5;
mplot = 6;
ind_plot = 1;
for i = 1:N
    disp(i);
    ind = centers(i); 
    
    % show center image
    filename = sprintf('../Images/%s/%s.JPG', cls, filenames{ind});
    I = imread(filename);
    subplot(nplot, mplot, ind_plot);
    ind_plot = ind_plot + 1;
    imshow(I);
    title(filenames{ind});
    
    % show several members
    member = find(idx == ind);
    member(member == ind) = [];
    num = numel(member);
    fprintf('%d examples\n', num+1);
    for j = 1:min(nplot*mplot-1, num)
        ind = member(j);       
        % show the image patch
        filename = sprintf('../Images/%s/%s.JPG', cls, filenames{ind});
        I = imread(filename);
        subplot(nplot, mplot, ind_plot);
        ind_plot = ind_plot + 1;
        imshow(I);
        title(filenames{ind});        
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
        ind_plot = 1;
        pause;
    end
end