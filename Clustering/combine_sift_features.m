function combine_sift_features

% load filenames
object = load('sift_features/filenames.mat');
filenames = object.filenames;

N = numel(filenames);
sift_features = [];
ids = [];
count = 0;
for i = 1:N
    fprintf('%d\n', i);
    % load descriptor
    object = load(sprintf('sift_features/%s.mat', filenames{i}));
    des = object.descriptors;
    n = size(des,1);
    sift_features(count+1:count+n,:) = des;
    ids(count+1:count+n,:) = i;
    count = count + n;
end

save('sift_features.mat', 'sift_features', 'ids', '-v7.3');