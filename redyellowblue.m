function [cmap] = redyellowblue(varargin)
%function [cmap] = redyellowblue(m=64)
%
%   Returns an mx3 red-beige-blue colormap.
%

if nargin>0
    n = varargin{1};
else
    n = 64;
end
red = [0.8500 0.3250 0.0980].^2;
blue = [0 0.4470 0.7410].^2;
yellow = [0.9290 0.6940 0.1250].^(1/10);
x = linspace(-1,1,n)';
gauss = @(x0,s) exp(-(x-x0).^2/(s*s));
rfunc = gauss(1,.6);
yfunc = gauss(0,.6);
bfunc = gauss(-1,.6);
cmap = red'*rfunc'+blue'*bfunc'+yellow'*yfunc';
cmap = cmap';
cmap = cmap./max(cmap(:));