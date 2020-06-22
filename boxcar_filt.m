function [x] = boxcar_filt(x,n,varargin)
%[X] = boxcar(X,N,dim=last)
%
%   applies a boxcar filter of length N to X along the specified dimension,
%   or the last dimension by default. ignores missing values

%see if a specific dimension was requested:
if ~isempty(varargin)
    dim = varargin{1};
else
    dim = ndims(x);
end

%reshape x to a 2D matrix
perm = [1:dim-1 dim+1:ndims(x) dim];
x = permute(x,perm);
sz = size(x);
x = reshape(x,[prod(sz(1:end-1)) sz(end)]);

%apply the filter
nx = isnan(x);
x(nx) = 0;
filter = ones(1,n);
x = conv2(x,filter,'same');
weight = conv2(double(~nx),filter,'same');
x = x./weight;
x(nx) = nan;

%reshape x to the original size
x = reshape(x,sz);
x = ipermute(x,perm);