function [X,Y,Z] = backproject_full(Z, P)

X = zeros(size(Z));
Y = zeros(size(Z));
Pinv = inv(P);
%backproject to make [X,Y,Z]
for v=1:size(Z,1)
    for u=1:size(Z,2)
        p = [u; v; Z(v,u); 1];
        vp = Pinv * p;
        X(v,u) = vp(1) / vp(4);
        Y(v,u) = vp(2) / vp(4);
        Z(v,u) = vp(3) / vp(4);
    end
end
