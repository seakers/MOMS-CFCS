function [matchingX,adjacent]=compareClustersFirstInXminDist(clusters,pointLocations, MSTy, archs, xDistFunc, isXDistVectorized)
[matchingY,adjacent]=compareClustersMatchFirst(clusters, pointLocations, MSTy);

%% find distances
distConn=cell(size(matchingY,1));
for indx=1:size(matchingY,1)
    cls1=matchingY{indx,1}; cls2=matchingY{indx,2};
    cls1pts= clusters==cls1; cls2pts=clusters==cls2;
    cls1locs=archs(cls1pts); cls2locs=archs(cls2pts);
    
    if isXDistVectorized
        distConn{indx}=xDistFunc(cls1locs, cls2locs);
    else
        distMat=NaN(size(cls1locs,1),size(cls2locs,1));
        for i=1:size(cls1locs,1)
            for j=1:size(cls2locs,1)
                distMat(i,j)=xDistFunc(cls1locs(i),cls2locs(j));
            end
        end
        distConn{indx}=distMat;
    end
end

%% for each pair of clusters, apply hungarian algorithm
clsPairs=cell2mat(matchingY(:,1:2));
for indx=1:size(matchingY,1)
    cls1=matchingY{indx};
    cls2=matchingY{indx};
    distMat=distConn{indx};
    [~,thisMatching]=min(distMat,[],2);
    matchingX(indx,:)={cls1,cls2,thisMatching};
end