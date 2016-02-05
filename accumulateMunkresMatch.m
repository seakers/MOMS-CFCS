function [connectivity, classMembership,matchingIndx]=accumulateMunkresMatch(clusters, locations, matching)
totalEdges=sum(cellfun(@(x) sum(x>0),matching(:,3)),1);
connectivity=nan(totalEdges,3);
matchingIndx=nan(totalEdges,1);
classMembership=nan(totalEdges,2);
currentStart=1;

for indx=1:size(matching,1)
    [cls1Used, cls2Used]=interpretMunkresMatching(clusters, matching{indx,1},matching{indx,2},matching{indx,3});
    y1=locations(cls1Used,:); y2=locations(cls2Used,:);
    dist=sqrt(sum((y1-y2).^2,2));
    
    thisSprseSubMat=[cls1Used,cls2Used,dist];
    thisSubset=currentStart:(currentStart-1+size(thisSprseSubMat,1));
    matchingIndx(thisSubset)=repmat(indx,size(cls1Used));
    classMembership(thisSubset,:)=[repmat(matching{indx,1},size(cls1Used)),repmat(matching{indx,2},size(cls2Used))];
    connectivity(thisSubset,:)=thisSprseSubMat;
    currentStart=currentStart+size(thisSprseSubMat,1);
end