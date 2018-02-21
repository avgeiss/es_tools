function [x] = detrenddim(x,varargin)
%[x] = detrenddim(x)
%
%[x] = detrenddim(x,dim)
%
%overrides the default behavior of detrend to operate on N-D matrices. By
%default trend is removed along last dimension, otherwise if a dimension is
%specified as the second argument it is removed along the specified
%dimension.
%

if nargin == 2
    dim = varargin{1};
else
    dim = ndims(x);
end

sz = size(x);
[x,iperm] = mat2d(x,dim);
x = anom(x);
trend = lintrend(x);
n = size(x,2)-1;
x = x-trend*(-n/2:n/2);
x = imat2d(x,iperm,sz);