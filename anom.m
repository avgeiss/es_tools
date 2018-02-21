function [X] = anom(X,varargin)
%[X] = anom(X)
%
%   removes the mean taken along the last dimension of X from all
%   corresponding values in X (computes the anomaly)
%
%
%[X] = anom(X,dim)
%
%   removes the mean taken along the dimension 'dim' of X from all
%   corresponding values in X (computes the anomaly)

%unpack inputs:
if nargin>1
    dim = varargin{1};
else
    dim = ndims(X);
end

%take anomaly
sz = size(X);
[X,iperm] = mat2d(X,dim);
mn = nanmean(X,2);
X = bsxfun(@minus,X',mn')';
X = imat2d(X,iperm,sz);