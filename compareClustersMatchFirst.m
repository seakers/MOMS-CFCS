function [matching]=compareClustersMatchFirst(clusters,pointLocations, MST)
numClusters=max(clusters);
[cls1list,cls2list]=ind2sub([numClusters,numClusters],1:numClusters*numClusters);
distinctPair=cls1list<cls2list;
cls1list=cls1list(distinctPair); cls2list=cls2list(distinctPair);
clsPairs=[cls1list;cls2list]';

%% find distances
[distConn,centerDists]=allDistBetweenClusters(clsPairs,clusters,pointLocations);
% distWithin=allDistWithinClusters(clusters,pointLocations);

%% for each pair of clusters, apply hungarian algorithm
matching=clusterHungarian(clsPairs,distConn,centerDists);

% stdFormMatching=accumulateMunkresMatch(clusters, pointLocations, matching);
% plotGraphPlus(figure(),pointLocations,stdFormMatching(:,1:2),[],clusters,[],[])

%% define notion of adjacency and find adjacent clusters
[adjacent]=adjacencyCheck(matching,pointLocations,clusters,MST);

%% kill non-adjacent links
matching(~adjacent,:)=[];