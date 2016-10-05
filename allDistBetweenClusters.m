function [distConn, centerDists]=allDistBetweenClusters(clsPairs,clusters,pointLocations)
distConn=cell(size(clsPairs,1),1);
centerDists=cell(size(clsPairs,1),1);
for(indx=1:size(clsPairs,1))
    cls1=clsPairs(indx,1); cls2=clsPairs(indx,2);
    cls1pts= clusters==cls1;
    cls1locs=pointLocations(cls1pts,:);
    cls2pts= clusters==cls2;
    cls2locs=pointLocations(cls2pts,:)';
    
    distsSqrd=repmat(sum(cls1locs.^2,2),1,size(cls2locs,2))+repmat(sum(cls2locs.^2,1),size(cls1locs,1),1)-2*cls1locs*cls2locs;
    
    cls1center=mean(cls1locs,1);
    cls2center=mean(cls2locs,2);
    center1dist2=repmat(sum(cls1center.^2,2),1,size(cls2locs,2))+repmat(sum(cls2locs.^2,1),size(cls1center,1),1)-2*cls1center*cls2locs;
    center2dist1=repmat(sum(cls1locs.^2,2),1,size(cls2center,2))+repmat(sum(cls2center.^2,1),size(cls1locs,1),1)-2*cls1locs*cls2center;
    
    distConn{indx}=distsSqrd;
    centerDists{indx}={center2dist1,center1dist2};
    
    % not true distances. Would need sqrt.
end