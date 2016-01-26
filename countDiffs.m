function diffsGrouping=countDiffs(diffFeat,clsMergeSz,sortMST)
sortMergeSz=sort(clsMergeSz,2);
radix=size(clsMergeSz,1)+1;
UID=sum(sortMergeSz.*repmat([radix,1],size(sortMergeSz,1),1),2); % note size(y,1) is # of merge operations
UIDfeat=bi2deSubstitute(diffFeat);
numDigit=size(diffFeat,2);

[usedFeats,featsSortIndx]=unique(UID);
meanDist=NaN(size(usedFeats,1),1);
featsSortMST=sortMST(featsSortIndx);
for id=usedFeats'
    meanDist(id)=mean(featsSortMST(id==usedFeats));
end

[~,meanSortIndx]=sort(featsSortMST);
sortUsedFeats=usedFeats(meanSortIndx);

diffsGrouping=cell(length(sortUsedFeats),3);
cnt=1;
for merge=sortUsedFeats'
    logicalFeatInst=UID==merge;
    featInst=UIDfeat(logicalFeatInst);
    featSets=unique(featInst); % UIDs of feature sets which have teh same merge pattern
    
    counts=histc(featInst,featSets);
    [sortCnts,cntIndx]=sort(counts,1,'descend');
    featSets=featSets(cntIndx);
      
    %% create output
    firstDigit=mod(merge,radix); % digits of the merge pattern (cluster sizes to merge)
    secondDigit=(merge-firstDigit)/radix;
    diffsGrouping{cnt,1}=[firstDigit,secondDigit];
    diffsGrouping{cnt,2}=de2biSubstitute(featSets,numDigit);
    diffsGrouping{cnt,3}=sortCnts;
    
    cnt=cnt+1;
end