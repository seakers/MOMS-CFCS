function [distConn]=allDistWithinClusters(clusters,pointLocations)
uIDs=unique(clusters);
distConn=cell(size(uIDs,1),1);
for(indx=1:length(uIDs))
    cls1=uIDs(indx,1);
    cls1pts= clusters==cls1;
    cls1locs=pointLocations(cls1pts,:);
    cls2pts= clusters==cls1;
    cls2locs=pointLocations(cls2pts,:)';
    
    distsSqrd=repmat(sum(cls1locs.^2,2),1,size(cls2locs,2))+repmat(sum(cls2locs.^2,1),size(cls1locs,1),1)-2*cls1locs*cls2locs;
    
    distConn{indx}=sqrt(distsSqrd);
end