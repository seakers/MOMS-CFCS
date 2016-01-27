%%MSTplot but colors of lines is based on distance of connection instead of
%%class merge size
function MSTplotDist(sortMST, links1, links2, points)
figure
hold on
set(gcf(),'Visible','off')
plot(points(:,1),points(:,2),'k.');

numElem=size(sortMST,1)+1;

for(indx=1:size(sortMST,1))
    el1=links1(indx); el2=links2(indx);
    pltX=[points(el1,1),points(el2,1)];
    pltY=[points(el1,2),points(el2,2)];
    
    lineClr=hsv2rgb([2/3*(1-sortMST(indx)/max(sortMST)),1,1]);
    plot(pltX,pltY,'-','Color',lineClr);
end
colorbar
set(gcf(),'Visible','on')

% movie(movieFrames,1,4);

%%for bigger stuff so don't spend as long rendering:
%http://www.mathworks.com/matlabcentral/answers/9572-keep-figures-from-popping-up-when-running
%http://stackoverflow.com/questions/4137628/render-matlab-figure-in-memory
%http://www.mathworks.com/matlabcentral/answers/99925-why-does-the-screensaver-get-captured-when-i-use-getframe-on-a-matlab-figure-window-while-creating-a