function [output] = convfilt2d(data,filt)
%computes the convolution of a data set with a filter, (handles nans while
%conv2 does not)

%need to do this in three parts to handle nans and edges so that the filter
%remains normalized wherever it is applied. e.g. sum(data(:)) =
%sum(output(:))

insum = nansum(data(:));

%make sure filter is conservative:
filt = filt/sum(filt(:));

%find missing data:
nanmask = isnan(data);
data(nanmask) = 0;
nanmask = double(~nanmask);

%perform convolutions:
datconv = conv2(data,filt,'same');
nanconv = conv2(nanmask,filt,'same');

%so correct for the missing filter weights:
output = datconv./nanconv;

%put nans back in place:
output(~logical(nanmask)) = nan;

%ensure sum of output is exactly the same as input:
endsum = nansum(output(:));
output = insum*output/endsum;
percchange = abs(endsum-insum)/((endsum+insum)/2);
if percchange > 0.1
    disp(['WARNING! Weight correction of ' num2str(round(percchange*100)) '% post-filtering']);
    disp('(convfilt2d: Line: 36)');
end
