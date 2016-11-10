function [matching]=clusterHungarian(clsPairs,distConn, varargin)
%%performs the hungarian algorithm on the objects given by distConn
%%varargin{1}=distance from each point to a reference point for the
%%purposes of matching elements to dummy points in the partial matching

matching=cell(size(clsPairs,1),3);


% the code quality is so terrible due to my hacking I could practically
% vomit.
if(length(distConn)~=size(clsPairs,1))
    error('input size mismatch. clsPairs should corespond to distances in distConn');
end

disp([num2str(size(clsPairs,1)),' connections']);
center=varargin{1};

for indx=1:size(distConn,1)
    thisDist=distConn{indx};
    wrkCls=clsPairs(indx,1);jobCls=clsPairs(indx,2);
    
    thisCenter=center{indx};

    [wrkCls,jobCls,assign, thisDist, ~]=partialMatchOne(thisDist, thisCenter, wrkCls, jobCls);
    if wrkCls==clsPairs(indx,1)
        thisCenterL=thisCenter{1};
        thisCenterR=thisCenter{2};
    else
        thisCenterL=thisCenter{2};
        thisCenterR=thisCenter{1};
    end
    
%% rematching for larger sets
%     toAssign=(assign==0);
%     while any(toAssign)
%         [newWrkCls,~,newAssign]=partialMatchOne(thisDist(toAssign,:), {thisCenterL(toAssign), thisCenterR}, wrkCls, jobCls); % assert: thisDist should never be fat when called. Will eventually get to where should be fat and then have to index 2nd indexs...but then would have finished last iteration.
%         toAssignIndxs=find(toAssign);
%         if wrkCls~=newWrkCls % had more jobs than workers and partialMatchOne has transposed.
%             jobIndxs=find(newAssign);
%             [~,newWorkIndxs]=sort(newAssign(jobIndxs));
%             workerIndxs=toAssignIndxs(newAssign(newAssign>0));
%             newAssign=zeros(length(toAssignIndxs),1);
%             newAssign(workerIndxs)=jobIndxs;
%             newAssign=jobIndxs(newWorkIndxs);
%         end
%         
%         assign(toAssignIndxs(newAssign>0))=newAssign(newAssign>0);
%         toAssign=(assign==0);
%     end
    
    matching(indx,:)={wrkCls,jobCls,assign};
end
%assign is a row vector which satisfies
%assign(cls1element)==assignedCls2element where cls1element are
%elements of the clusters with labels adjacent{i,1} and
%adjacent{i,2} respectively.
return

function [wrkCls,jobCls,assign, thisDist, centerDist]=partialMatchOne(thisDist, centerDistsCell, wrkCls, jobCls)
% this whol thing could be cleaned up if kept consistent left/right instead
% of job/wrk classes
    [wrkrs,jobs]=size(thisDist);
    setCenter=false;
    if(wrkrs<jobs) % insure more workers than jobs
        tmp=wrkrs;
        wrkrs=jobs;
        jobs=tmp;
        
        tmp=wrkCls;
        wrkCls=jobCls;
        jobCls=tmp;
        thisDist=thisDist'; % thisDist is tall.
        
        if nargin>2
            thisCenter=centerDistsCell;
            centerDist=repmat(thisCenter{2},wrkrs-jobs,1)';
            setCenter=true;
        end
    end
    if nargin>2 && ~setCenter
        thisCenter=centerDistsCell;
        centerDist=repmat(thisCenter{1},1,wrkrs-jobs);
    end
    
%     disp([num2str(indx), '<- indx | perfect Match size ->', num2str(jobs)])
    
    %the mixer mixes up indicies when used inside the ().
    %the unmixer tells who became the input index when used inside the ().
    %the mixer also tells who got the input index when used outside the ().
    wrkMixer=randperm(wrkrs); jobMixer=randperm(jobs);
    [~,wrkUnmixer]=sort(wrkMixer); 
%     [~,jobUnmixer]=sort(jobMixer);
    unmixDist=thisDist;
    thisDist=thisDist(wrkMixer,jobMixer);
    if nargin>2
        fullDist=[thisDist, centerDist];
    else
        fullDist=thisDist;
    end
    [assign,~]=munkres(fullDist); %sqrt unnecessary
    assign(assign>jobs)=0;
    assign(assign>0)=jobMixer(assign(assign>0));
    assign=assign(wrkUnmixer);
    thisDist=unmixDist;
    
    % assign is a vector the length of the workCls and has indicies 0
    % (unmatched) through number of jobcls elements with workcls which are
    % matchings between a given element in the jobclass to the elements in
    % workclass.
%     unmatched=(assign==0);
%     [~,toMatch]=min(unmixDist(unmatched,:),[],2);
%     assign(unmatched)=toMatch;
    
return