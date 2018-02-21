function [x] = imat2d(x,iperm,sz)
%[x] = imat2d(x,iperm,sz)
%
%   performs the inverse operation of mat2d, converting a 2D matrix back to
%   its original size. 'iperm' is the inverse permutation info returned by
%   'mat2d' and 'sz' is the original size of the matrix returned by 'size'.
%

x = reshape(x,sz(iperm));
x = ipermute(x,iperm);