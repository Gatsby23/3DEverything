function split_training_images

% root_dir = '/home/yuxiang/Projects/3DEverything/Primitives';
azimuth = 0:15:345;
elevation = 0:15:90;
yaw = 0:30:330;
per_test = 0.2;

% read class names
fid = fopen('classes.txt', 'r');
C = textscan(fid, '%s');
classes = C{1};
fclose(fid);
N = numel(classes);

% filenames
train_images = [];
train_depths = [];
test_images = [];
test_depths = [];
count_train = 0;
count_test = 0;

% for each class
for c = 1:N
    cls = classes{c};
    disp(cls);
    files = dir(sprintf('CAD/%s/*.obj', cls));
    % number of CAD models
    num = numel(files);
    
    % number of CAD models for testing
    num_test = max(round(num * per_test), 1);
    num_train = num - num_test;
    
    outdir = cls;
    
    % for each CAD model
    for i = 1:num
        % render for each viewpoint
        for a = azimuth
            for e = elevation
                for y = yaw
                    filename_image = sprintf('%s/cad%02d_a%03d_e%02d_y%03d_image.jpg', outdir, i, a, e, y);
                    filename_depth = sprintf('%s/cad%02d_a%03d_e%02d_y%03d_depth.jpg', outdir, i, a, e, y);
                    % add an auxiliary class label to be zero for using
                    % caffe
                    if i <= num_train
                        count_train = count_train + 1;
                        train_images{count_train} = sprintf('%s %d', filename_image, 0);
                        train_depths{count_train} = sprintf('%s %d', filename_depth, 0);
                    else
                        count_test = count_test + 1;
                        test_images{count_test} = sprintf('%s %d', filename_image, 0);
                        test_depths{count_test} = sprintf('%s %d', filename_depth, 0);
                    end
                end
            end
        end
    end
end

fprintf('%d training image, %d test images\n', count_train, count_test);

% shuffle the training and test images
index_train = randperm(count_train);
index_test = randperm(count_test);

% output files
fid_train_images = fopen('train_images.txt', 'w');
fid_train_depths = fopen('train_depths.txt', 'w');
fid_test_images = fopen('test_images.txt', 'w');
fid_test_depths = fopen('test_depths.txt', 'w');

for i = 1:count_train
    fprintf(fid_train_images, '%s\n', train_images{index_train(i)});
    fprintf(fid_train_depths, '%s\n', train_depths{index_train(i)});
end

for i = 1:count_test
    fprintf(fid_test_images, '%s\n', test_images{index_test(i)});
    fprintf(fid_test_depths, '%s\n', test_depths{index_test(i)});
end

fclose(fid_train_images);
fclose(fid_train_depths);
fclose(fid_test_images);
fclose(fid_test_depths);