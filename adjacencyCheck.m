function [adjacent]=adjacencyCheck(matching,pointLocations,clusters,MST)
% get a matrix of edges connecting dissimilar clusters to be hungarianed.
% take the area occupied by the cluster to be the union of balls of radius bubbleWidth around
% points in a given cluster. Clusters are adjacent iff the lines connecting
% points do not intersect the space occupied by other clusters.

adjacent=nan(size(matching,1),1);

% subClusterMSTs=arrayfun(@(cls)
% graph_EMST(pointLocations(clusters==cls,:)),unique(clusters),'UniformOutput',false);
% %invertia: delauney triangulation fails here returns empty edge set on
% 2nd input.. Original attempt to do without passin gin the MST directly.
% MST=max(cellfun(@(x) max(max(x)),subClusterMSTs,'UniformOutput',true));
fullMST=full(MST);
bubbleWidth=max(arrayfun(@(cls) max(max(fullMST(clusters==cls,clusters==cls))),unique(clusters)));

for(indx=1:size(matching,1))
    [cls1used,cls2used]=interpretMunkresMatching(clusters,matching{indx,1},matching{indx,2},matching{indx,3});
    
    cls1locs=pointLocations(cls1used,:);
    cls2locs=pointLocations(cls2used,:);
    chkAgainst= clusters~=matching{indx,1} & clusters~=matching{indx,2};
    againstLoc=pointLocations(chkAgainst,:);
    
    passings=linePassThroughBall(cls1locs,cls2locs,againstLoc,2*bubbleWidth);
    adjacent(indx)=(~squeeze(any(any(passings)))); 
end