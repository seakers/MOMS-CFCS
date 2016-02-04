function [mergeSizes]=clusterSizes(sortMST, links1, links2)
numElem=size(sortMST,1)+1;
clsSize=ones(numElem,numElem-1);
clsRep=1:numElem;
mergeSizes=nan(numElem-1,2); % size of each cluster before merge. Sum together to get new cluster size

for indx=1:size(sortMST,1)
    el1=links1(indx); 
    el2=links2(indx);
    
    % find representer elements of each cluster (set)
    loEl=min(el1,el2);
    repLo=clsRep(loEl); prevRepLo=loEl;
    while repLo~=prevRepLo
        prevRepLo=repLo;
        repLo=clsRep(repLo);
    end
    hiEl=max(el1,el2);
    repHi=clsRep(hiEl); prevRepHi=hiEl;
    while repHi~=prevRepHi
        prevRepHi=repHi;
        repHi=clsRep(repHi);
    end
    
    mergeSizes(indx,:)=[clsSize(repLo), clsSize(repHi)];
    
    %merge. Using lower index for convenience
    %Can prove somehow that by taking the larger as the new representer get faster
    clsRep(repHi)=repLo;
    clsSize(repLo)=clsSize(repHi)+clsSize(repLo);
end
return