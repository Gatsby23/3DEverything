function compute_conv_matching

features = read_conv_features;
N = size(features, 2);
similarity = zeros(N, N);

for i = 1:N
    fprintf('%d\n', i);
    f1 = features(:,i);
    for j = i:N
        f2 = features(:,j);
        s = dot(f1,f2) / (norm(f1) * norm(f2));
        similarity(i,j) = s;
        similarity(j,i) = s;
    end
end

save('similarity_conv.mat', 'similarity', '-v7.3');