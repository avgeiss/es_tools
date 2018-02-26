function x = pixelate(x,n)
%function x = pixelate(x,n)
%
%   Take nxn pixel means along the first two dimensions of the matrix 'x'
%   if the size of x along a dimension is not an integer multiple of 'n'
%   then x is padded with nans at the end of that dimension before taking
%   mean
%   

%deal with extra dimensions if there are any:
szin = size(x);
x = reshape(x,[szin(1:2) prod(szin(3:end))]);

%pad x if its size is not a multiple of n
x = padarray(x,mod(-szin([1 2]),n),nan,'post');

%take the average:
sz = size(x);
x = reshape(x,[n sz(1)/n n sz(2)/n sz(3:end)]);
x = nanmeandims(x,[1 3]);

%reshape before returning:
x = reshape(x,[sz(1:2)/n szin(3:end)]);