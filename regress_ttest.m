function [b,bint] = regress_ttest(y,x,alpha,varargin)
%function [b,bint] = regress_ttest(y,x,alpha)
%
%   Performs regression, solving y = bx. bint is a 1-alpha confidence
%   interval for the regression coefficient. Confidence is estimated using
%   a 2-sided t-test, where the number of degrees of freedom is estimated
%   based on Bretherton et al. 1999. x and y are expected to be vectors.
%

%check inputs are proper size & shape
szy = size(y);
szx = size(x);
if (szx(1) ~= szy(1)) || (szy(2)~=1) || (szx(2)~=1)
    error('Improperly formatted input vectors');
end

%check that there is input data:
if all(isnan([x;y]))
    b = nan;bint = nan;
    return;
end

%remove anomaly:
y = anom(y,1);
x = anom(x,1);

%remove missing data:
missing = any(isnan([x,y]),2);
y = y(~missing);
x = x(~missing);

%compute regression coefficient:
b = (y'*x)./(x'*x);

%get effective NDOF assuming some serial-correlation:
if length(varargin)<1
    rx = corr(x(1:end-1),x(2:end));
    ry = corr(y(1:end-1),x(2:end));
    N = length(x);
    nu = min(N*(1-rx*ry)/(1+rx*ry),N);      %see Bretherton et al. 1999
else
    nu = varargin{1};
end

%get confidence interval:
se = norm(y-b*x)/norm(x)/sqrt(nu);      %standard error
se = sqrt(mean((y-b*x).^2)/sum(x.^2));
tv = tinv(1-alpha/2,nu);                %t-value
bint = b+[-1 1]*se*tv;                  %confidence interval