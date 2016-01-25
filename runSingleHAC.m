function [MST, Z, features1, features2, sortMST, links1, links2, clsSizes]=runSingleHAC(x,y)
[~,uniqX]=unique(x,'rows');
if length(uniqX)~=size(x,1)
%     x=x(uniqX,:);
%     y=y(uniqX,:);

    error('nonunique input test values detected (x has nonuniqe rows)');
end
[~,uniqY, invUniqY]=unique(y,'rows');
xSav=x; % note: the corresponding y's are given as y(invUniqY,:);
% cleanedY=true;
% x=x(uniqY,:);
y=y(uniqY,:);

Z=linkage(y,'single','euclidean');
dendrogram(Z,100);

% addpath('../ExtUtils/indexDunnMod/');
options.show=0;
[MSTreal,~,~]=graph_EMST(y,options);
%% add duplicate y's as identical-element clusters
%make non-links inf to distinguish.
MST=MSTreal(invUniqY,invUniqY);

smallVal=1e-6;
dupVals=find(histc(invUniqY,1:length(uniqY))>=2);
for val=dupVals'
    locs=find(invUniqY==val);
    for inst=2:length(locs)
        MST(locs(inst),:)=0;
        MST(:,locs(inst))=0;
        MST(locs(inst),locs(inst-1))=smallVal;
    end
end

%% extracting features
% [row,col]=find(MST<inf);
[row,col]=find(MST);
[sortMST,sortMSTindx]=sort(MST(sub2ind(size(MST),row,col))); % by sorting, get cluster merge order

links1=row(sortMSTindx);
links2=col(sortMSTindx);

features1=xSav(links1,:);
features2=xSav(links2,:);

clsSizes=clusterSizes(sortMST, links1,links2);
% clsSizes=nan;