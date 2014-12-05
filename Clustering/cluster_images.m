function cluster_images 

fprintf('load similarity scores from file\n');
object = load('similarity_conv.mat');
scores = object.similarity;

pscale = 1.5;
p = min(min(scores)) * pscale;
disp(p);

% clustering
fprintf('Start AP clustering\n');
[idx_ap, netsim, dpsim, expref] = apclustermex(scores, p);

fprintf('Number of clusters: %d\n', length(unique(idx_ap)));
fprintf('Fitness (net similarity): %f\n', netsim);

save('idx_ap.mat', 'idx_ap');