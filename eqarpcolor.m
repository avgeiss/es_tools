function [ax] = eqarpcolor(ln,lt,data,hatch)
%function [ax] = eqarpcolor(ln,lt,data,hatch)
%
%   Pcolor on a map axis with coastline:
%   'ln' - Longitudes
%   'lt' - Latitude
%   'data' - data to plot
%   'hatch' - binary matrix of size(data) indicating locations to put
%       hashmarks, or [] if no hashmarks.
%

%assuming that the values in data correspond exactly to the locations in ln
%and lt, then the lat and lon range are bigger than the maximum values of
%lat and lon by half a pixel width, so account for this:
dx = mean(diff(ln(1,:)));
dy = mean(diff(lt(:,1)'));
latrange = [min(lt(:)) max(lt(:))]+[-0.0001 0.0001];
lonrange = [min(ln(:)) max(ln(:))]+[-0.0001 0.0001];
if lonrange(1) == -0.0001;lonrange(1) = 0;end
if lonrange(2) == 360.0001;lonrange(2) = 360;end

if ~any(hatch(:));hatch = [];end;

%there are three possible projections depending on the area to be plotted
if diff(sign(latrange)) == 0
    %then we are only in one hemisphere:
    if abs(diff(lonrange))>180
        %in both hemispheres, use a global equal area projection
        projection = 'eckert4';
        origin = [0 mean(lonrange) 0];
        if min(abs(latrange))>20
            %use a conic projection:
            projection = 'eqaazim';
            origin=0;
            latrange = [min(abs(latrange)) 90]*sign(mean(latrange));
        end
        ax = axesm('MapProjection',projection,'Grid','off','MapLatLimit',latrange,...
            'MapLonLimit',lonrange,'Origin',origin,'fontsize',12,'MLabelLocation',...
            lonrange,'labelrotation','off','fontsize',12);
    else
        %otherwise use a conic projection for less distortion:
        projection = 'eqaconicstd';
        origin = [mean(latrange) mean(lonrange) 0];
        ax = axesm('MapProjection',projection,'Grid','off','MapParallels',latrange,'MapLatLimit',latrange,...
            'MapLonLimit',lonrange,'Origin',origin,'fontsize',12,'MLabelLocation',...
            lonrange,'labelrotation','off','fontsize',12);
    end
else
    %in both hemispheres, use a global equal area projection
    projection = 'eckert4';
    origin = [0 mean(lonrange) 0];
    ax = axesm('MapProjection',projection,'Grid','on','MapLatLimit',latrange,...
        'MapLonLimit',lonrange,'Origin',origin,'fontsize',12,'MLabelLocation',...
        lonrange+round((diff(lonrange)/4)*[1 -1]),'labelrotation','on','fontsize',12);
end
    
%create the map axes:
tightmap;  
axis off;
mlabel on;  plabel on;  

%do the coloring:
pcolorm(lt,ln,data);

%don't put hatches in to nan pixels:
if ~isempty(hatch)
lowerhatch = hatch;upperhatch = hatch;
lowerhatch(isnan(circshift(data,[1 1])+circshift(data,[1 0])+circshift(data,[0 1]))) = 0;
upperhatch(isnan(circshift(data,[-1 -1])+circshift(data,[0 -1])+circshift(data,[-1 0]))) = 0;

%add hatching:
if any(upperhatch(:))
    plotm([lt(upperhatch(:)) lt(upperhatch(:))+dy/2]',[ln(upperhatch(:)) ln(upperhatch(:))+dx/2]','k-','linewidth',1);
end
if any(lowerhatch(:))
    plotm([lt(lowerhatch(:)) lt(lowerhatch(:))-dy/2]',[ln(lowerhatch(:)) ln(lowerhatch(:))-dx/2]','k-','linewidth',1);
end
end

%add a landmask:
load coast;
geoshow(lat,long,'DisplayType','polygon','FaceColor','k','edgecolor','w');
%geoshow(lat,long,'displaytype','line','color','black','linewidth',2);