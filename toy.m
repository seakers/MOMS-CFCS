[xx,xy]=meshgrid(linspace(-1,1,64));

y=NaN(size(xx,1),size(xx,2),2);
y1=tanh(xx+xy);
y(:,:,1)=y1;
y1min=min(min(y(:,:,1)));
y1max=max(max(y(:,:,1)));

y2=1./(1+xx.^2+xy.^2);
y(:,:,2)=y2;
y2min=min(min(y(:,:,2)));
y2max=max(max(y(:,:,2)));

yDat=[y1(:),y2(:)];
% Z=linkage(ydat,'single','euclidean');
options.show=0;
addpath('../ExtUtils/indexDunnMod/');
addpath('../ExtUtils/wgPlot');
[MST,~,~]=graph_EMST(yDat,options);
plotMSTclusters(MST,yDat);



%% make an overlay plot to indicate the relations between inputs and output variables
% see example 5 of:
% http://www.mathworks.com/matlabcentral/answers/101346-how-do-i-use-multiple-colormaps-in-a-single-figure 
% FAILS if MATLAB version <2014b
% h1=figure;
% h2a=axes;
% colormap(h2a,'hot');
% cont2=contour(xx,xy,y(:,:,2));
% cb2=colorbar;
% set(cb2,'Location','west')
% caxis(cb2,[y1min,y1max]);
% h1a=axes;
% colormap(h1a,'cool');
% 
% cont1=contour(xx,xy,y(:,:,1));
% cb1=colorbar;
% set(cb1,'Location','East')
% axis(h1a,'off');
% 
% linkaxes([h1a,h2a]);

%% trying again with freezecolors
% http://www.mathworks.com/matlabcentral/fileexchange/7943-freezecolors---unfreezecolors
% addpath('../extUtils/cm_and_cb_utilities/');
addpath('../extUtils/freezeColors/');
h1=figure
hold on
S_hndl=plot(xx(:),xy(:),'.');
set(S_hndl,'MarkerSize',4);
h1a=axes;
cont1=contour(xx,xy,y(:,:,1));
colormap hot
freezeColors
axis(h1a,'off');

h2a=axes;
cont2=contour(xx,xy,y(:,:,2));
colormap cool
axis(h2a,'off');
linkaxes([h1a,h2a]);

hold off
figure
plot(y(:,:,1),y(:,:,2),'k.')

