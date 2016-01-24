function [MST, Z, features1, features2, sortMST, links1, links2, clsSizes]=runSingleHAC(x,y)
[~,uniqX]=unique(x,'rows');
if length(uniqX)~=size(x,1)
%     x=x(uniqX,:);
%     y=y(uniqX,:);

    error('nonunique input test values detected (x has nonuniqe rows)');
end
[~,uniqY, invUniqY]=unique(y,'rows');
if length(uniqY)~=size(y,1);
    cleanedY=true;
    xSav=x; % note: the corresponding y's are given as y(invUniqY,:);
    x=x(uniqY,:);
    y=y(uniqY,:);
end

Z=linkage(y,'single','euclidean');
dendrogram(Z,100);

% addpath('../ExtUtils/indexDunnMod/');
options.show=0;
[MSTreal,~,~]=graph_EMST(y,options);

%% add duplicate y's as identical-element clusters
%make non-links inf to distinguish.
dupVals=find(histc(invUniqY,1:length(uniqY))>=2);
MSTreal(~MSTreal)=inf;
MST=MSTreal(invUniqY,invUniqY);

MST(sub2ind(size(MST),

% figure
% plotMSTclusters(MST,y)

%% extracting features
[row,col]=find(MST<inf);
[sortMST,sortMSTindx]=sort(MST(sub2ind(size(MST),row,col))); % by sorting, get cluster merge order

links1=row(sortMSTindx);
links2=col(sortMSTindx);

features1=x(links1,:);
features2=x(links2,:);

clsSizes=clusterSizes(sortMST, links1,links2);
% clsSizes=nan;