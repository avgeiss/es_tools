function [av,div] = winds_to_vort_div(u,v,lat,lon)
%function [abs_vort,div] = winds_to_vort_div(u,v,lat,lon)
%
%takes lat/lon gridded wind vectors as inputs and computes vorticity and
%divergence fields, assumes lat and lon are the first two dims of inputs,
%may have any number of trailing dimensions.

%get spacing between grid points:
dm = 111000;%distance between lat/lon lines at equator in meters.
dx = dm*cosd(lat);
sz = size(u);
dx = repmat(dx,[1 1 sz(3:end)]);
dy = dm*ones(size(u));

%compute gradients:
[ux,uy] = gradient(u);
[vx,vy] = gradient(v);

%do vorticity calculation:
div = ux./dx + vy./dy;
av = vx./dx - uy./dy;