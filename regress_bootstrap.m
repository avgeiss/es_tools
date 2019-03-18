function [b,bint] = regress_bootstrap(y,x,alpha,nresample,window)
%function [b,bint] = regress_ttest(y,x,alpha,nresample,window)
%
%   Performs regression, solving y = bx. bint is a 1-alpha confidence
%   interval for the regression coefficient. Confidence is estimated using
%   a moving blocks bootstrap. nresample is the number of times to resample
%   the signal, window is the block size.
%

%check inputs are proper size & shape
szy = size(y);
szx = size(x);
if (szx(1) ~= szy(1)) || (szy(2)~=1) || (szx(2)~=1)
    error('Improperly formatted input vectors');
end

%remove anomaly:
y = anom(y,1); x = anom(x,1);

%remove missing data:
missing = any(isnan([x,y]),2);
y = y(~missing); x = x(~missing);

%gets the set of nresample possible coefficients:
b = bootstrap(y,x,window,nresample);

%get the interval:
bint = b([floor(nresample*alpha/2),end-floor(nresample*alpha/2)+1]);

%get the actual regression coef:
b = (y'*x)/(x'*x);
bint = b+bint;

function [b] = bootstrap(y,x,W,I)
N = length(y);NW = ceil(N/W);
perms = kron(ceil(rand(I,NW)*N),ones(1,W));                                %generate permutations
perms = mod(perms+repmat(0:W-1,[I NW])-1,N)+1;
b = (y(perms(:,1:N))*x)/(x'*x);                                            %do the regression
b = sort(b,'ascend');