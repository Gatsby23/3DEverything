function [Nx,Ny,Nz,valid] = computeNormals(D, params)

[Xd,Yd,Zd] = backproject(D, params);
[Nx, Ny, Nz] = surfnorm(Xd,Yd,Zd);

%scale to units
N = Nx.^2 + Ny.^2 + Nz.^2;
N = N.^0.5;
Nx = Nx ./ N; Ny = Ny ./ N; Nz = Nz ./ N;

%compute valid map
valid = D > 0 & D < 1;