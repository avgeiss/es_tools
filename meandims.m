function [output] = meandims(input,dims)
%[output] = nanmeandims(input,dims)
%
%takes an average along each of the dimensions specified in 'dims' and
%reduces the number of dimensions of the result with 'squeeze.' NaNs are
%ignored. When an observation along a dimension is populated entirely wiht
%NaNs, returns a NaN.

for i = 1:length(dims)
    allnan = all(isnan(input),dims(i));
    input = mean(input,dims(i));
    input(allnan) = NaN;
end
output = squeeze(input);