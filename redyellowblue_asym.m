function [cmap] = redyellowblue_asym(varargin)
%function [cmap] = redyellowblue(crange)
%
%   Returns an mx3 red-beige-blue colormap.
%

%parse inputs
%number of colors in output colormap
if nargin==2
    m = varargin{2};
else
    m = 64;
end

%asymmetrical color range around zero
crange = varargin{1};

%generate the colormap
n = 1000;
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

%break into blue and red components and resize:
by = cmap(1:500,:);
yr = cmap(501:end,:);
nblue = round(-m*(crange(1)/diff(crange)));
nred =  m-nblue;
red = interp1(yr,linspace(1,500,nred));
blue = interp1(by,linspace(1,500,nblue));
cmap = [blue;red];





