function compute_sift_matching

matlabpool open;

distRatio = 0.6;

% load filenames
object = load('sift_features/filenames.mat');
filenames = object.filenames;

N = numel(filenames);
similarity = zeros(N, N);
parfor i = 1:N
    tic;
    fprintf('%d\n', i);
    % load descriptor
    object = load(sprintf('sift_features/%s.mat', filenames{i}));
    des1 = object.descriptors;
    n = size(des1,1);
    if n == 0
        continue;
    end
    for j = 1:N
        % load descriptor
        object = load(sprintf('sift_features/%s.mat', filenames{j}));
        des2 = object.descriptors;
        
        % sift matching
        if size(des2,1) < 2
            num = 0;
        else
            M = sort(acos(des1 * des2'), 2);
            num = sum(M(:,1) < distRatio * M(:,2));
        end        
        
        similarity(i,j) = num / n;
    end
    toc;
end

save('similarity.mat', 'similarity', '-v7.3');

matlabpool close;