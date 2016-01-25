function summaryTxt=countDiffs(diffFeat,clsMergeSz,sortMST)
sortMergeSz=sort(clsMergeSz,2);
radix=size(clsMergeSz,1)+1;
UID=sum(sortMergeSz.*repmat([radix,1],size(sortMergeSz,1),1),2); % note size(y,1) is # of merge operations
UIDfeat=bi2deSubstitute(diffFeat);

[usedFeats,featsSortIndx]=unique(UID);
meanDist=NaN(size(usedFeats,1),1);
featsSortMST=sortMST(featsSortIndx);
for id=usedFeats'
    meanDist(id)=mean(featsSortMST(id==usedFeats));
end

[~,meanSortIndx]=sort(featsSortMST);
sortUsedFeats=usedFeats(meanSortIndx);

summaryTxt=cell(length(sortUsedFeats));
cnt=1;
for merge=sortUsedFeats'
    logicalFeatInst=UID==merge;
    featInst=UIDfeat(logicalFeatInst);
    featSets=unique(featInst);
    
    counts=histc(featInst,featSets);
    
    %% display output
    firstDigit=mod(merge,radix);
    secondDigit=(merge-firstDigit)/radix;
    summaryTxtLine=['merges: ',num2str([firstDigit,secondDigit]),' total: ',num2str(sum(logicalFeatInst)), ' | '];
    for i=1:length(counts)
        summaryTxtLine=[summaryTxtLine,'(',num2str(de2bi(featSets(i))),', ',num2str(counts(i)),') '];
    end
    summaryTxt{cnt}=summaryTxtLine;
    cnt=cnt+1;
end