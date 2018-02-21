function [x,perm_idx] = mat2d(x,dims)
%[x,permidx] = mat2d(x,dims)
%
%   converts the multi-dimensional matrix 'x' to a 2D matrix. The
%   dimensions of 'x' listed in 'dims' become the second dimension of the
%   output while all remaining dimensions become the first. 'permidx' are
%   contains the indices of the permutation performed on the original
%   matrix to do this (to be used with ipermute).
%
sz = size(x);
perm_dims = 1:ndims(x);
perm_dims(dims) = [];
perm_idx = [perm_dims dims];
x = permute(x,perm_idx);
x = reshape(x,[prod(sz(perm_dims)) prod(sz(dims))]);