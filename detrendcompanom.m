function [x] = detrendcompanom(x,comp_len,dim)
%function [x] = detrendcompanom(x,comp_len,dim)
%
%removes the linear trend, composite cycle, and mean along the specified
%dimension:
x = detrenddim(x,dim);
x = removecomposite(x,comp_len,dim);
x = anom(x,dim);