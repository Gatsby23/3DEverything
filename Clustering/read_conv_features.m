function features = read_conv_features

filename = 'features.dat';
fid = fopen(filename, 'r');
features = fread(fid, 'float32');

dim_f = 4096;
dim_n = numel(features) / dim_f;
features = reshape(features, dim_f, dim_n);