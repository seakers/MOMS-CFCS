function [distConn]=allDistBetweenClusters(clsPairs,clusters,pointLocations)
distConn=cell(size(clsPairs,1),1);
for(indx=1:size(clsPairs,1))
    cls1=clsPairs(indx,1); cls2=clsPairs(indx,2);
    cls1pts= clusters==cls1;
    cls1locs=pointLocations(cls1pts,:);
    cls2pts= clusters==cls2;
    cls2locs=pointLocations(cls2pts,:)';
    
    distsSqrd=repmat(sum(cls1locs.^2,2),1,size(cls2locs,2))+repmat(sum(cls2locs.^2,1),size(cls1locs,1),1)-2*cls1locs*cls2locs;
    
    distConn{indx}=sqrt(distsSqrd);
end