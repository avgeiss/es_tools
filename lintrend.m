function [trends] = lintrend(X,varargin)
%function [trends] = lintrend(X,dim=last)
%
%Computes linear trends for each signal contained in the matrix X.

if nargin>1
    dim = varargin{1};
else
    dim = ndims(X);
end

sz = size(X);
X = mat2d(X,dim);
trends = linearTrend(X);
if numel(sz)>2
    sz(dim) = [];
    trends = reshape(trends,sz);
end

function [a] = linearTrend(x)
%computes a linear trend along each row of the matrix 'x'
[N,M] = size(x);
y = repmat(1:M,[N 1]);
y(isnan(x)) = nan;
yb = repmat(nanmean(y,2),[1 M]);
xb = repmat(nanmean(x,2),[1 M]);
a = nansum((x-xb).*(y-yb),2)./nansum((y-yb).^2,2);