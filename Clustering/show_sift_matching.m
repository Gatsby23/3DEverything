function show_sift_matching

cls = 'chair';

% load filenames
object = load('sift_features/filenames.mat');
filenames = object.filenames;
N = numel(filenames);

mplot = 5;
nplot = 10;
index_plot = 0;
for i = 1:N
    % read image
    filename = sprintf('../Images/%s/%s.JPG', cls, filenames{i});
    I = imread(filename);
    index_plot = index_plot + 1;
    subplot(mplot, nplot, index_plot);
    imshow(I);
    title(filenames{i});
    
    % load matching results
    filename = sprintf('sift_matching/%s_sim.mat', filenames{i});
    object = load(filename);
    similarity = object.similarity;
    [~, index] = sort(similarity, 'descend');
    
    % show matched images
    for j = 1:nplot-1
        ind = index(1+j);
        if similarity(ind)
            filename = sprintf('../Images/%s/%s.JPG', cls, filenames{ind});
            I = imread(filename);
            index_plot = index_plot + 1;
            subplot(mplot, nplot, index_plot);
            imshow(I);
            tit = sprintf('%s:%.2f', filenames{ind}, similarity(ind));
            title(tit);
        else
            index_plot = index_plot + 1;
        end
    end
    
    if index_plot == mplot * nplot
        index_plot = 0;
        pause;
    end
end