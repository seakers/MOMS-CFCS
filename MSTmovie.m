%%creates an animated movie of the sortMST clustering process.
%%diffText is a cell arrapoints (vector) which contains text to displapoints at each
%%step indicating the difference between the merged architectures.
%%takes an optional argument of the cluster sizes (see clustersize
%%function). which will make the colors represent the cluster sizes.
%%Otherwise line colors are scaled distance of the linkage
%%REMEMBER: movie2avi(movieFrames,'filename.avi',framerate) saves the
%%movie. movie(movieFrames) plapointss the movie
function movieFrames=MSTmovie(sortMST, links1, links2, points, diffTxt, ~)
figure
hold on
plot(points(:,1),points(:,2),'.');

frames=size(sortMST,1);
movieFrames(frames)=struct('cdata',[],'colormap',[]);

numElem=size(sortMST,1)+1;
clsSize=ones(numElem,1);
clsRep=1:numElem;

txtH=text(0,0,'');
for(indx=1:frames)
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

    set(txtH,'Visible','off'); %remove previous text box.
    lineClr=hsv2rgb([2/3*(1-clsSize(repLo)/numElem),1,1]);
    plot(pltX,pltY,'-','Color',lineClr);
    txtH=text(mean(pltX)*1.03,mean(pltY)*1.03,diffTxt{indx});
    movieFrames(indx)=getframe(gcf());
end

% movie(movieFrames,1,4);

%%for bigger stuff so don't spend as long rendering:
%http://www.mathworks.com/matlabcentral/answers/9572-keep-figures-from-popping-up-when-running
%http://stackoverflow.com/questions/4137628/render-matlab-figure-in-memory
%http://www.mathworks.com/matlabcentral/answers/99925-why-does-the-screensaver-get-captured-when-i-use-getframe-on-a-matlab-figure-window-while-creating-a