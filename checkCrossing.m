function [adjacent]=checkCrossing(clsPairs,clusters,pointLocations,bubbleWidth)
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