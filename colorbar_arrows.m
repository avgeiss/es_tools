function colorbar_arrows(cb,varargin)
%function colorbar_arrows(colorbar_handel,{'top','bottom'})
%
%adds triangles to the ends of a colorbar to indicate that some plotted
%values might saturate the color scale
%
%if 'top' or 'bottom' is specified, only adds arrow to one side of the
%color bar

%parse optional inputs:
top = true;
bottom = true;
if ~isempty(varargin)
    if strcmp(varargin{1},'top')
        bottom = false;
    elseif strcmp(varargin{1},'bottom')
        top = false;
    else
        disp('Unrecognized option:');
        disp(varargin{1});
    end
end

%get arrow plotting info:
p = cb.Position;
asprat = get(gcf,'position');
asprat = asprat(4)/asprat(3);
d = 0.001;
cmap = colormap;

%create invisible axis to draw triangles on
ax = axes('position',[0 0 1 1],'visible','off');
hold on;

if p(3)>p(4) %then a horizontally oriented colorbar:
    if bottom
        f = fill([p(1)-p(4)*asprat p(1)+d p(1)+d],[p(2)+p(4)/2 p(2) p(2)+p(4)],cmap(1,:));
        set(f,'EdgeColor','none');
    end
    if top
        f = fill([p(1)+p(3)+p(4)*asprat p(1)+p(3)-d p(1)+p(3)-d],[p(2)+p(4)/2 p(2) p(2)+p(4)],cmap(end,:));
        set(f,'EdgeColor','none');
    end
else %vertically oriented colorbar:
    if bottom
        f = fill([p(1)+p(3)/2 p(1) p(1)+p(3)],[p(2)-p(3)/asprat p(2) p(2)],cmap(1,:));
        set(f,'EdgeColor','none');
    end
    if top
        f = fill([p(1)+p(3)/2 p(1) p(1)+p(3)],[p(2)+p(4)+p(3)/asprat p(2)+p(4) p(2)+p(4)],cmap(end,:));
        set(f,'EdgeColor','none');
    end
end

%make sure axes are sized properly:
xlim([0 1]);
ylim([0 1]);
axis off;