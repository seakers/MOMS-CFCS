function [MST, Z, sortMST, links1, links2, clsSizes]=runSingleHAC(x,y)
Z=linkage(y,'single','euclidean');
dendrogram(Z,100);

addpath('../ExtUtils/indexDunnMod/');
options.show=0;
[MST,~,~]=graph_EMST(y,options);

% figure
% plotMSTclusters(MST,y)

%% extracting features
[row,col]=find(MST);
[sortMST,sortMSTindx]=sort(MST(sub2ind(size(MST),row,col))); % by sorting, get cluster merge order
links1=row(sortMSTindx);
links2=col(sortMSTindx);

clsSizes=clusterSizes(sortMST, links1,links2);
