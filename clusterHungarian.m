function [matching]=clusterHungarian(clsPairs,distConn, varargin)
matching=cell(size(clsPairs,1),3);

if(length(distConn)~=size(clsPairs,1))
    error('input size mismatch. clsPairs should corespond to distances in distConn');
end

disp([num2str(size(clsPairs,1)),' connections']);
for indx=1:size(distConn,1)
    thisDist=distConn{indx};
    wrkCls=clsPairs(indx,1);jobCls=clsPairs(indx,2);
    
    [wrkrs,jobs]=size(thisDist);
    setCenter=false;
    if(wrkrs<jobs)
        tmp=wrkrs;
        wrkrs=jobs;
        jobs=tmp;
        
        tmp=wrkCls;
        wrkCls=jobCls;
        jobCls=tmp;
        thisDist=thisDist';
        
        if nargin>2
            center=varargin{1};
            thisCenter=center{indx};
            centerDist=repmat(thisCenter{2},wrkrs-jobs,1)';
            setCenter=true;
        end
    end
    if nargin>2 && ~setCenter
        center=varargin{1};
        thisCenter=center{indx};
        centerDist=repmat(thisCenter{1},1,wrkrs-jobs);
    end
    
    disp([num2str(indx), '<- indx | perfect Match size ->', num2str(jobs)])
    
    %the mixer mixes up indicies when used inside the ().
    %the unmixer tells who became the input index when used inside the ().
    %the mixer also tells who got the input index when used outside the ().
    wrkMixer=randperm(wrkrs); jobMixer=randperm(jobs);
    [~,wrkUnmixer]=sort(wrkMixer); 
%     [~,jobUnmixer]=sort(jobMixer);
    thisDist=thisDist(wrkMixer,jobMixer);
    if nargin>2
        fullDist=[thisDist, centerDist];
    else
        fullDist=thisDist;
    end
    [assign,~]=munkres(sqrt(fullDist)); %sqrt unnecessary
    assign(assign>jobs)=0;
    assign(assign>0)=jobMixer(assign(assign>0));
    assign=assign(wrkUnmixer);
    
    matching(indx,:)={wrkCls,jobCls,assign};
end
%assign is a row vector which satisfies
%assign(cls1element)==assignedCls2element where cls1element are
%elements of the clusters with labels adjacent{i,1} and
%adjacent{i,2} respectively.
return