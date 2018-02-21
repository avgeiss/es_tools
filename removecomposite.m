function [in] = removecomposite(in,period,varargin)
%
%   [OUT] = removeCompositeSig(IN,PERIOD)
%   [OUT] = removeCompositeSig(IN,PERIOD,DIM)
%
%   Removes a composited signal with period PERIOD from the data IN. By
%   default operates along the last dimension of the data unless specified
%   in DIM. Ignores NaNs. OUT has the same dimensions as IN.

%make the compositing dimension the first one:
dim = ndims(in);
if ~isempty(varargin)
    dim = varargin{1};
end
in = shiftdim(in,dim-1);

%make the matrix 2-D:
sz = size(in);
in = reshape(in,[sz(1) prod(sz(2:end))]);

%check for missing data:
if any(any(isnan(in)) & any(~isnan(in)))
    warning(['Some of the time-series contain missing data, this breaks the'...
        ' linear property: deseasonalize(field_mean(data)) = field_mean(deseasonalize(data))']);
end

%remove the composite:
M = nanmean(in);
for i = 1:period
    inds = i:period:sz(1);
    in(inds,:) = in(inds,:) - repmat(nanmean(in(inds,:))-M,[length(inds) 1]);
end

%reshape the data:
in = reshape(in,sz);
in = shiftdim(in,ndims(in)-dim+1);