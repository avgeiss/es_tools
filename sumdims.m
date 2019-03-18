function [output] = nansumdims(input,dims)
%[input] = nansumdims(input,dims)
%
%Sums along each of the dimensions specified in 'dims' and reduces the
%number of dimensions in the result with 'squeeze.' NaNs are treated as
%zeros. When an observation along a dimension is populated entirely wiht
%NaNs, returns a NaN.

for i = 1:length(dims)
    allnan = all(isnan(input),dims(i));
    input = sum(input,dims(i));
    input(allnan) = NaN;
end
output = squeeze(input);