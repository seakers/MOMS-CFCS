function [crosses,distances]=linePassThroughBall(lineEndpoint1,lineEndpoint2,ballCenter,ballRadius)  
    vecDim=size(lineEndpoint1,2);
    numLine=size(lineEndpoint1,1);
    numComp=size(ballCenter,1);
    
    compX1=repmat(lineEndpoint1,1,1,numComp);
    compX2=repmat(lineEndpoint2,1,1,numComp);
    compX2rel=compX2-compX1;
    
    compComp=repmat(reshape(ballCenter',1,vecDim,numComp),[numLine,1,1]);
    compCompRel=compComp-compX1;
    
    t=sum(compCompRel.*compX2rel,2)./sum(compX2rel.^2,2);
    distances=sum((compCompRel-repmat(t,[1,vecDim,1]).*compX2rel).^2,2);
    
    crosses=distances<ballRadius.^2;
    crosses(t<0 | t>1)=false;
    crosses=squeeze(crosses);
    distances=squeeze(distances);
%     lineEndpoint2=lineEndpoint2';
%     m=size(lineEndpoint1,1); n=size(lineEndpoint2,2); numChk=size(ballCenter,1);
%     vecDim=size(lineEndpoint1,2);
%     
%     stdX1=repmat(reshape(lineEndpoint1,m,1,vecDim),[1,n,1]);
%     stdX2=repmat(reshape(lineEndpoint2',1,n,vecDim),[m,1,1]);
%     stdX2rel=stdX2-stdX1;
%     
%     compX1=repmat(stdX1,[1,1,1,numChk]); 
% %     compX2=repmat(stdX2,[1,1,1,numChk]); 
%     compX2rel=repmat(stdX2rel,[1,1,1,numChk]);
%     compBallCenter=repmat(reshape(ballCenter',[1,1,vecDim,numChk]),m,n);
%     compBallCenterRel=compBallCenter-compX1;
%     t=sum(compBallCenterRel.*compX2rel,3)./sum(compX2rel.^2,3);
%     distances=sum((compBallCenterRel-repmat(t,[1,1,vecDim,1]).*compX2rel).^2,3);
%     crosses=distances<repmat(ballRadius^2,[m,n,1,numChk]);
%     crosses(t<0 | t>1)=false;
return