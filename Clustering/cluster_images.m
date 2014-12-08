function cluster_images

cls = 'table';

fprintf('load similarity scores from file\n');
object = load(sprintf('similarity_conv_%s.mat', cls));
scores = object.similarity;

pscale = 1.5;
p = min(min(scores)) * pscale;
disp(p);

% clustering
fprintf('Start AP clustering\n');
[idx_ap, netsim, dpsim, expref] = apclustermex(scores, p);

fprintf('Number of clusters: %d\n', length(unique(idx_ap)));
fprintf('Fitness (net similarity): %f\n', netsim);

save(sprintf('idx_ap_%s.mat', cls), 'idx_ap');