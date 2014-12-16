function cluster_normal_patches

addpath('/home/yuxiang/Projects/3DEverything/3rd_party/vggkmeans');

% clustering parameters
K = 1000;

% load normal patches
object = load('normal_patches.mat');
patches = object.patches;

% construct clustering features
N = numel(patches);
M = numel(patches(1).normals);
X = zeros(M, N);
for i = 1:N
    X(:,i) = patches(i).normals(:);
end

% kmeans clustering
fprintf('2d kmeans %d\n', K);
opts = struct('maxiters', 1000, 'mindelta', eps, 'verbose', 1);
[center, sse] = vgg_kmeans(X, K, opts);
[idx_kmeans, d] = vgg_nearest_neighbour(X, center);

% construct idx
idx = zeros(N, 1);
for i = 1:K
    index = find(idx_kmeans == i);
    [~, ind] = min(d(index));
    cid = index(ind);
    idx(index) = cid;
end

save('idx.mat', 'idx');