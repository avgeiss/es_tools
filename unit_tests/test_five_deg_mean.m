%test_five_deg_mean.m

dx = 0.85;
dy = 0.65;
[lon,lat] = meshgrid((0:dx:360)+rem(360,dx)/2,(-90:dy:90)+rem(180,dy)/2);
x1 = tanh(sqrt((lon-180).^2 + lat.^2)/90);
x2 = tanh((lon+abs(lat))/180);
x2(abs(lon+lat*2-180)<40) = nan;
x3 = exp(-(lat/60+cosd(lon*3)).^2);
x1(x3>0.9) = nan;
x3(abs(lat)<20) = nan;
x = cat(3,x1,x2,x3);
x = repmat(x,[1 1 1 100]);
tic;
[ox,olat,olon] = five_deg_mean(x,lat,lon);
toc
for i = 1:3
    subplot(2,3,i);
    pcolor(lon,lat,x(:,:,i,41));
    colorbar;
    shading interp;
    subplot(2,3,i+3);
    pcolor(olon,olat,ox(:,:,i,43));
    colorbar;
end
