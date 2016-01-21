function [clsSize]=clusterSizes(sortMST, links1, links2)
clsSize=ones(size(x,1),1);
clsRep=1:size(x,1);

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