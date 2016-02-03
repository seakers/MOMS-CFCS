function [matching]=compareClustersMatchFirst(clusters,pointLocations, bubbleWidth)
numClusters=max(clusters);
[cls1list,cls2list]=ind2sub([numClusters,numClusters],1:numClusters*numClusters);
distinctPair=cls1list<cls2list;
cls1list=cls1list(distinctPair); cls2list=cls2list(distinctPair);
clsPairs=[cls1list;cls2list]';

%% find distances
distConn=allDistBetweenClusters(clsPairs,clusters,pointLocations);

%% for each pair of adjacent clusters, apply hungarian algorithm
matching=cell(size(clsPairs,1),4);

for indx=1:size(distConn,1)
    thisDist=distConn{indx};
    [wrkrs,jobs]=size(thisDist);
    if(wrkrs>=jobs)
        [assign,totalCost]=munkres(sqrt(thisDist)); %sqrt unnecessary
        matching(indx,:)={clsPairs(indx,1),clsPairs(indx,2),assign,totalCost};
    else
        [assign,totalCost]=munkres(sqrt(thisDist')); %sqrt unnecessary
        matching(indx,:)={clsPairs(indx,2),clsPairs(indx,1),assign,totalCost};
    end
end
%assign is a row vector which satisfies
%assign(cls1element)==assignedCls2element where cls1element are
%elements of the clusters with labels adjacent{i,1} and
%adjacent{i,2} respectively.

%% define notion of adjacency and find adjacent clusters
% get a matrix of edges connecting dissimilar clusters to be hungarianed.
% take the area occupied by the cluster to be the union of balls of radius bubbleWidth around
% points in a given cluster. Clusters are adjacent iff the lines connecting
% points do not intersect the space occupied by other clusters.

%check if lines used in matching cross space controlled by other clusters.
adjacent=nan(size(matching,1),1);
for(indx=1:size(matching,1))
    [cls1used,cls2used]=interpretMunkresMatching(clusters,matching{indx,1},matching{indx,2},matching{indx,3});
    
    cls1locs=pointLocations(cls1used,:);
    cls2locs=pointLocations(cls2used,:);
    chkAgainst= clusters~=matching{indx,1} & clusters~=matching{indx,2};
    againstLoc=pointLocations(chkAgainst,:);
    
    passings=linePassThroughBall(cls1locs,cls2locs,againstLoc,bubbleWidth);
    adjacent(indx)=(~squeeze(any(any(passings)))); 
end

%% kill non-adjacent links
matching(~adjacent,:)=[];