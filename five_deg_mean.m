function [xm,olat,olon,kern] = five_deg_mean(x,varargin)
%function [x,lat,lon] = five_deg_mean(x,lat,lon)
%
%takes 5 degree means of gridded data for high res input lat/lon
%Assumes the  first two dimensions of the input are lat and lon
%respectively. Can have any number of additional dimensions. Assigns each
%input to its nearest neighbor using the haversine formula, and then takes
%the mean of all assigned points.
%
%If the same interpolation needs to be done more than once, a sparse kernel
%matrix can be passed instead of lat and lon:
%[~,~,~,kern] = five_deg_mean(x,lat,lon);
%then:
%[x,lat,lon] = five_deg_mean(x,kern);
%
%(should be pretty easy to modify this to work for scattered inputs but I
%don't need that functionality right now. also adding functionality for
%non-global datasets should be easy)

%process inputs:
if nargin==3
    lat = varargin{1};
    lon = varargin{2};
elseif nargin == 2
    kern = varargin{1};
end

%first define the output lat/lon grid:
[olon,olat] = meshgrid(2.5:5:357.5,-87.5:5:87.5);
gsz = size(olon);
olon = olon(:);olat = olat(:);

%find mapping for interpolation:
if nargin ~= 2
    N = numel(lon);
    idxs = zeros(N,1);
    for i = 1:N
        d = haversine(lat(i),olat,lon(i),olon);
        [~,idxs(i)] = min(d);
    end
    kern = sparse(idxs,(1:N)',ones(N,1),numel(olon),N);
end

%apply the kernel:
sz = size(x);
[x,iperm] = mat2d(x,[1 2]);
x = x';
%count the number of observations going into each mean:
count = kern*double(~isnan(x));
nancount = kern*double(isnan(x));
x(isnan(x)) = 0;%missing data wont be used in means
%get the means:
xm = kern*x;
xm = xm./count;
%in cases where more than half the inputs were missing output nan:
xm(nancount>count) = nan;

%reshape data:
xm = xm';
sz([1 2]) = gsz;
xm = imat2d(xm,iperm,sz);
olon = reshape(olon,gsz);
olat = reshape(olat,gsz);

function [d] = haversine(lt1,lt2,ln1,ln2)
d = sind((lt2-lt1)/2).^2+cosd(lt1).*cosd(lt2).*sind((ln2-ln1)/2).^2;