%%spews a bunch of frames from the cluster movie.
linkageStats=inconsistent(Z);
cutoffs=sort(unique(linkageStats(linkageStats(:,4)>0,4)),'descend');

frames=size(cutoffs,1);
movieFrames(frames)=struct('cdata',[],'colormap',[]);

markers=['.x+*sdo^v><ph'];
markerSize=[5,5,5,5,3,3,3,3,3,3,3,3,3];
colors=['krbgm'];

indx=1;
for(cutIndx=1:frames)
    cls=cluster(Z,'cutoff',cutoffs(cutIndx));
    if(size(points,1)>2000 && max(cls)>size(points,1)/1.3) % I just don't want all of it.
        movieFrames(cutIndx:end)=[];
        break
    end
    
    mrkIndx=1;
    clrIndx=1;
    h=figure();
    hold on
    title(['cutoff inconsistency',num2str(cutoffs(cutIndx),)]);
    
    for(clsIndx=1:max(cls))
        plot(points(cls==clsIndx,1),points(cls==clsIndx,2),[colors(clrIndx),markers(mrkIndx)],'MarkerSize',markerSize(mrkIndx));
       
        clrIndx=clrIndx+1;
        if(clrIndx>length(colors))
            clrIndx=1;
            mrkIndx=mrkIndx+1;
            if(mrkIndx>length(markers))
                mrkIndx=1;
                if ~(exist('warningIssue','var'))
                    warning(['ran out of distinctive markers for clusters:', num2str(max(cls)),' clusters']);
                    warningIssue=logical(true);
                end
            end
        end
    end
    movieFrames(indx)=getframe(gcf());
    indx=indx+1;
    delete(h)
end

% movie(movieFrames,1,4);

%%for bigger stuff so don't spend as long rendering:
%http://www.mathworks.com/matlabcentral/answers/9572-keep-figures-from-popping-up-when-running
%http://stackoverflow.com/questions/4137628/render-matlab-figure-in-memory
%http://www.mathworks.com/matlabcentral/answers/99925-why-does-the-screensaver-get-captured-when-i-use-getframe-on-a-matlab-figure-window-while-creating-a