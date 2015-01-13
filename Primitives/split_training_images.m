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

% output files
fid_train_images = fopen('train_images.txt', 'w');
fid_train_depths = fopen('train_depths.txt', 'w');
fid_test_images = fopen('test_images.txt', 'w');
fid_test_depths = fopen('test_depths.txt', 'w');

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
                        fprintf(fid_train_images, '%s %d\n', filename_image, 0);
                        fprintf(fid_train_depths, '%s %d\n', filename_depth, 0);
                    else
                        fprintf(fid_test_images, '%s %d\n', filename_image, 0);
                        fprintf(fid_test_depths, '%s %d\n', filename_depth, 0);
                    end
                end
            end
        end
    end
end

fclose(fid_train_images);
fclose(fid_train_depths);
fclose(fid_test_images);
fclose(fid_test_depths);