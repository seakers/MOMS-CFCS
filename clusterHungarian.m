function [matching]=clusterHungarian(clsPairs,distConn)
matching=cell(size(clsPairs,1),3);

if(length(distConn)~=size(clsPairs,1))
    error('input size mismatch. clsPairs should corespond to distances in distConn');
end

disp([num2str(size(clsPairs,1)),' connections']);
for indx=1:size(distConn,1)
    thisDist=distConn{indx};
    wrkCls=clsPairs(indx,1);jobCls=clsPairs(indx,2);
    
    [wrkrs,jobs]=size(thisDist);
    if(wrkrs<jobs)
        tmp=wrkrs;
        wrkrs=jobs;
        jobs=tmp;
        
        tmp=wrkCls;
        wrkCls=jobCls;
        jobCls=tmp;
        thisDist=thisDist';
    end
    
    disp([num2str(indx), '<- indx | perfect Match size ->', num2str(jobs)])
    
    %the mixer mixes up indicies when used inside the ().
    %the unmixer tells who became the input index when used inside the ().
    %the mixer also tells who got the input index when used outside the ().
    wrkMixer=randperm(wrkrs); jobMixer=randperm(jobs);
    [~,wrkUnmixer]=sort(wrkMixer); 
%     [~,jobUnmixer]=sort(jobMixer);
    thisDist=thisDist(wrkMixer,jobMixer);
    
    [assign,~]=munkres(sqrt(thisDist)); %sqrt unnecessary
    
    assign(assign>0)=jobMixer(assign(assign>0));
    assign=assign(wrkUnmixer);
    
    matching(indx,:)={wrkCls,jobCls,assign};
end
%assign is a row vector which satisfies
%assign(cls1element)==assignedCls2element where cls1element are
%elements of the clusters with labels adjacent{i,1} and
%adjacent{i,2} respectively.
return