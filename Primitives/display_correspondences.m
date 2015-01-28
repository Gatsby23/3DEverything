function display_correspondences

filename = 'labels_correspondences/aeroplane/002000.mat';
object = load(filename);
cor = object.cor;
corX = cor.corX;
corY = cor.corY;
width = size(corX, 2);
height = size(corY, 1);

% read image
I1 = imread(cor.image_left);
I2 = imread(cor.image_right);

% show the match
I3 = appendimages(I1,I2);
figure(1);

for x = 1:width
    for y = 1:height
        if corX(y,x) ~= 0 && corY(y,x) ~= 0
            loc1 = [x y];
            loc2 = [corX(y,x) corY(y,x)];

            imshow(I3);
            hold on;
            plot(loc1(1), loc1(2), 'ro');
            plot(loc2(1)+width, loc2(2), 'ro');
            line([loc1(1) loc2(1)+width], [loc1(2) loc2(2)], 'Color', 'c');
            hold off;
            pause;
        end
    end
end