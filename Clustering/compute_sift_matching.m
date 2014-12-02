function compute_sift_matching(index)

matlabpool open;

distRatio = 0.6;

% load filenames
object = load('sift_features/filenames.mat');
filenames = object.filenames;

N = numel(filenames);
parfor i = 1:numel(index)
    ind = index(i);
    fprintf('%d\n', ind);
    similarity = zeros(1, N);
    % load descriptor
    object = load(sprintf('sift_features/%s.mat', filenames{ind}), 'descriptors');
    des1 = object.descriptors;
    n = size(des1,1);
    if n ~= 0
        for j = 1:N
            % load descriptor
            object = load(sprintf('sift_features/%s.mat', filenames{j}), 'descriptors');
            des2 = object.descriptors;

            % sift matching
            if size(des2,1) < 2
                num = 0;
            else
                M = sort(acos(des1 * des2'), 2);
                num = sum(M(:,1) < distRatio * M(:,2));
            end        

            similarity(j) = num / n;
        end
    end
    
    parsave(sprintf('sift_matching/%s_sim.mat', filenames{ind}), similarity);
end

matlabpool close;

function parsave(filename, similarity)

save(filename, 'similarity');