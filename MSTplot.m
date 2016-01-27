%%last frame of MSTmovie
function MSTplot(sortMST, links1, links2, points)
figure
hold on
set(gcf(),'Visible','off')
plot(points(:,1),points(:,2),'k.');

numElem=size(sortMST,1)+1;
clsSize=ones(numElem,1);
clsRep=1:numElem;

for(indx=1:size(sortMST,1))
    el1=links1(indx); el2=links2(indx);
    pltX=[points(el1,1),points(el2,1)];
    pltY=[points(el1,2),points(el2,2)];
    
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

    lineClr=hsv2rgb([2/3*(1-clsSize(repLo)/numElem),1,1]);
    plot(pltX,pltY,'-','Color',lineClr);
end
colorbar
set(gcf(),'Visible','on')