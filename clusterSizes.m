%%ERROR: defunct. fails to return proper cluster sizes
%%TODO:fix. always point to same numbers so clusters are easy to
%%distinguish at every step. maintain sizes at each step too
%%better method is to use built-in linkage function
%%or see MSTmovie for an example of how to do it while looping through for
%%processing.
function [clsSize]=clusterSizes(sortMST, links1, links2)
numElem=size(sortMST,1)+1;
clsSize=ones(numElem,numElem-1);
clsRep=1:numElem;

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
    
    %merge. Using lower index for convenience
    %Can prove somehow that by taking the larger as the new representer get faster
    clsRep(repHi)=repLo;
    clsSize(repLo)=clsSize(repHi)+clsSize(repLo);
end
return