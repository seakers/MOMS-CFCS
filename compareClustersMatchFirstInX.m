function [matchingX,matchingY,adjacent]=compareClustersMatchFirstInX(clusters,pointLocations, MSTy, xDistFunc, xDistVectorized)
numClusters=max(clusters);
[cls1list,cls2list]=ind2sub([numClusters,numClusters],1:numClusters*numClusters);
distinctPair=cls1list<cls2list;
cls1list=cls1list(distinctPair); cls2list=cls2list(distinctPair);
clsPairs=[cls1list;cls2list]';

[matchingY,adjacent]=compareClustersMatchFirst(clusters, pointLocations, MSTy);

%% find distances
for indx=1:size(clsPairs,1)
    if xDistVectorized
        distConn{i}=xDistFunc()
    else
        for indxClusterPair=1:
            distMat(i,j)=
            distConn{i}=distMat
        end
    end
end
    

%% for each pair of clusters, apply hungarian algorithm
matchingX=clusterHungarian(clsPairs,distConn,centerDists);