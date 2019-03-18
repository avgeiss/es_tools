function [x,mean,std] = normalize(x,varargin)
%function [x] = normalize(x,dim)
%
%   Normalizes the data in 'x' with respect to the last dimension, or 'dim'
%   if specified.

if nargin>1
    dim = varargin{1};
else
    dim = ndims(x);
end
mean = nanmean(x,dim);
std = nanstd(x,[],dim);
sz = size(x);
[x,iperm] = mat2d(x,dim);
x = x';
x = bsxfun(@minus,x,nanmean(x));
x = bsxfun(@rdivide,x,nanstd(x));
x = imat2d(x',iperm,sz);