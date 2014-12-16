function [Nx,Ny,Nz,Xd,Yd,Zd, valid] = computeNormals(D, P)

% fx = P(1,1);
% fy = P(2,2);
% cx = -P(1,3);
% cy = -P(2,3);
% params = [fx, fy, cx, cy];
% [Xd,Yd,Zd] = backproject(D, params);

P(:,3) = -P(:,3);
[Xd,Yd,Zd] = backproject_full(D, P);

[Nx, Ny, Nz] = surfnorm(Xd,Yd,Zd);

%scale to units
N = Nx.^2 + Ny.^2 + Nz.^2;
N = N.^0.5;
Nx = Nx ./ N; Ny = Ny ./ N; Nz = Nz ./ N;

%compute valid map
valid = D > 0 & D < 1;