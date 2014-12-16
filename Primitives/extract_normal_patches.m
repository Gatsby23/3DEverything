function extract_normal_patches

% parameters
sbin = 8;
psize = [4 4];
pnum = 32;
threshold = 0.5;
is_save = 1;

% read class names
fid = fopen('classes.txt', 'r');
C = textscan(fid, '%s');
classes = C{1};
fclose(fid);

classes = {'chair'};

N = numel(classes);

patches = [];
count = 0;

for c = 1:N
    cls = classes{c};
    
    % check normal images
    files = dir(sprintf('training_images/%s/*_normal.jpg', cls));
    num = numel(files);
    
    % for each normal image
    for i = 1:num
        filename = sprintf('training_images/%s/%s', cls, files(i).name);
        fprintf('%s\n', filename);
        normals = imread(filename);
        
        % compute gray image from normals
        gray = rgb2gray(normals);
        I = repmat(gray, [1 1 3]);
        
        % compute HOG
        f = features(double(I), sbin);
        
        % compute HOG placement
        pfilters = mkpartfilters(f(:,:,19:27), psize, pnum);
        
        % get the energy
        energy = zeros(pnum, 1);
        for j = 1:pnum
            energy(j) = pfilters(j).energy;
        end
        
        % sort the placement
        [~, index] = sort(energy, 'descend');
        pfilters = pfilters(index);
        
        % extract patches
        for j = 1:pnum
            if pfilters(j).energy < threshold
                break;
            end        
            anchor = pfilters(j).anchor;
            x = (anchor(1)+2) * sbin + sbin/2;
            y = (anchor(2)+2) * sbin + sbin/2;
            w = psize(1)*sbin;
            h = psize(2)*sbin;
            x1 = round(x - w/2);
            y1 = round(y - h/2);
            x2 = x1 + w - 1;
            y2 = y1 + h - 1;
            patch = normals(y1:y2, x1:x2, :);
            count = count + 1;
            patches(count).cls = cls;
            patches(count).image = files(i).name;
            patches(count).x1 = x1;
            patches(count).y1 = y1;
            patches(count).x2 = x2;
            patches(count).y2 = y2;
            patches(count).normals = patch;
        end
        
        
        if is_save == 0
            % plot normals
            for j = 1:pnum
                if pfilters(j).energy < threshold
                    break;
                end        
                anchor = pfilters(j).anchor;
                x = (anchor(1)+2) * sbin + sbin/2;
                y = (anchor(2)+2) * sbin + sbin/2;
                plot(x, y, 'bo', 'LineWidth', 2);
                w = psize(1)*sbin;
                h = psize(2)*sbin;
                bbox = [x-w/2 y-h/2 w h];

                x1 = round(x - w/2);
                y1 = round(y - h/2);
                x2 = x1 + w - 1;
                y2 = y1 + h - 1;
                patch = normals(y1:y2, x1:x2, :);            

                subplot(1, 2, 1);
                imshow(normals);
                hold on;            
                rectangle('Position', bbox, 'EdgeColor', 'r', 'LineWidth', 2);
                hold off;

                subplot(1, 2, 2);
                imshow(patch);

                pause;
            end
        end
    end
end
fprintf('%d normal patches extracted\n', count);

if is_save
    save('normal_patches.mat', 'patches', '-v7.3');
end