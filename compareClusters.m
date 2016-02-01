function [matching]=compareClusters(clusters,pointLocations, bubbleWidth)
numClusters=max(clusters);
[cls1list,cls2list]=ind2sub([numClusters,numClusters],1:numClusters*numClusters);
distinctPair=cls1list<cls2list;
cls1list=cls1list(distinctPair); cls2list=cls2list(distinctPair);
clsPairs=[cls1list;cls2list]';

%% find distances
distConn=allDistBetweenClusters(clsPairs,clusters,pointLocations);

%% define notion of adjacency and find adjacent clusters
% get a matrix of edges connecting dissimilar clusters to be hungarianed.
% take the area occupied by the cluster to be the union of balls of radius bubbleWidth around
% points in a given cluster. Clusters are adjacent iff the lines connecting
% points do not intersect the space occupied by other clusters.

%all points in cluster1 must be reachable to any other point in cluster 2
%without crosssing into region controlled by another cluster
%fails in the circle example because opposing edges of the circles cross
%the centerpoint.
adjacent=nan(size(clsPairs,1),1);
for(indx=1:size(clsPairs,1))
    cls1=clsPairs(indx,1); cls2=clsPairs(indx,2);
    cls1pts= clusters==cls1;
    cls2pts= clusters==cls2;
    chkAgainst= clusters~=cls1 & clusters~=cls2;
    
    cls1locs=pointLocations(cls1pts,:);
    cls2locs=pointLocations(cls2pts,:);
    againstLoc=pointLocations(chkAgainst,:);
    
    passings=linePassThroughBall(cls1locs,cls2locs,againstLoc,bubbleWidth);    
    adjacent(indx)=(~squeeze(any(any(any(passings))))); 
end

%% for each pair of adjacent clusters, apply hungarian algorithm
matching=cell(size(adjacent,1),4);
for(indx=1:size(adjacent,1))
    if(~adjacent(indx))
        matching(indx,:)={clsPairs(indx,1),clsPairs(indx,2),[],[]};
    else
        thisDist=distConn{indx};
        [wrkrs,jobs]=size(thisDist);
        if(wrkrs>=jobs)
            [assign,totalCost]=munkres(sqrt(thisDist)); %sqrt unnecessary
            matching(indx,:)={clsPairs(indx,1),clsPairs(indx,2),assign,totalCost};
        else
            [assign,totalCost]=munkres(sqrt(thisDist')); %sqrt unnecessary
            matching(indx,:)={clsPairs(indx,2),clsPairs(indx,1),assign,totalCost};
        end
        %assign is a row vector which satisfies
        %assign(cls1element)==assignedCls2element where cls1element are
        %elements of the clusters with labels adjacent{i,1} and
        %adjacent{i,2} respectively.
    end
end