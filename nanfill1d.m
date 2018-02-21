function [x] = nanfill1d(x,varargin)
%[x] = nanfill1d(x,dim=last)
%
%   Fills missing values in x in a way that is appropriate for time-series:
%   linearly interpolates boundary values over sections of the time series
%   that contain NaNs. If the entire time-series is NaN returns as-is.
%

%process inputs
if nargin>1
    dim = varargin{1};
else
    dim = ndims(x);
end

%convert to 2D matrix:
sz = size(x);
[x,iperm] = mat2d(x,dim);

%do forward and backward passes of nearest neighbor interpolation:
[fp,fw] = nnfill(x);
[bp,bw] = nnfill(flip(x,2));
bp = flip(bp,2);bw = flip(bw,2);

%handle cases where the beginning or end of the time-series had missing
%data:
fw(isnan(fp)) = 1;
bw(isnan(fp)) = 0;
fw(isnan(bp)) = 0;
bw(isnan(bp)) = 1;
bp(isnan(bp)) = 0;
fp(isnan(fp)) = 0;

%convert distances into weights for interpolation:
fw_new = bw./(fw+bw);
bw = fw./(fw+bw);
fw = fw_new;

%set weights for data that is present:
fw(~isnan(x)) = 1;
bw(~isnan(x)) = 0;

%convert to a linear interpolation:
x = fp.*fw + bp.*bw;

%reshape and return:
x = imat2d(x,iperm,sz);


function [x,dists] = nnfill(x)
%fills in missing data using last non-nan value (like nearest neighbor but
%directional). Also keeps track of distance from last valid datapoint

sz = size(x);
dists = zeros(sz);
nancount = isnan(x(:,1));
dists(:,1) = nancount;
for i = 2:sz(2)
    nanlocs = isnan(x(:,i));
    nancount = (nancount+nanlocs).*nanlocs;
    dists(:,i) = nancount;
    x(nanlocs,i) = x(nanlocs,i-1);
end