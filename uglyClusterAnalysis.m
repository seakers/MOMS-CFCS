%%performs basic cluster analysis. inputs:
%%y objective space positions
%%varargin{1} radius of ball around which points occupy OBSOLETED
%%varargin{1} MST corresponding to the points y.
%%varargin{2:end} inputs for breaking clusters.
function [Z,matchingEdges,matchSizes,matchSizesForFeatMatch,matching]=uglyClusterAnalysis(y,varargin)
% function [Z,matchingEdges]=uglyClusterAnalysis(y,varargin)
MST=varargin{1};

%% form linkage with MATLAB builtin
Z=linkage(y,'single','euclidean');

figure
dendrogram(Z,100);
% linkageStats=inconsistent(Z) % outputs statistics relating to inconsistency--the distance of the links relative to the average underneath them (roughly). Col 1, mean heights of all links used, col 2 std dev of all links used, col 3 number of links used, col 4 inconsistency coefficient
% cophnetCorr=cophenet(Z,pdist(y,'euclidean')) % correlation between cophenetic distance (distance in tree) to distances in space. Probably not useful in our interpretation of problem.
% cutoffCls=cluster(Z,'cutoff',varargin{2:end}); % the interesting stuff seems to hapen between 1.1 and 1.2
cutoffCls=cluster(Z,varargin{2:3});

lbls=[num2str(cutoffCls),repmat(' , ',size(cutoffCls,1),1),num2str([1:size(cutoffCls,1)]')];
figure
colormap('Lines');
% plotGraphPlus(gcf(),y,[],[],cutoffCls,[],mat2cell(lbls,ones(size(lbls,1),1),size(lbls,2)));
plotGraphPlus(gcf(),y,[],[],cutoffCls,[],[]);
clsSizesGlobal=arrayfun(@(cls) sum(cutoffCls==cls),sort(unique(cutoffCls)),'UniformOutput',true);

%% down-sampling.
numFolds=varargin{4};
filterFactor=varargin{5};
[folds,whichFold]=kfoldCrossVal(size(y,1),numFolds,cutoffCls);
plotGraphPlus([],y,[],[],whichFold,[],mat2cell(lbls,ones(size(lbls,1),1),size(lbls,2)));
% [folds,whichFold]=uRandFoldCrossVal(size(y,1),numFolds,cutoffCls);
% plotGraphPlus([],y,[],[],[],[],cellfun(@(anElem) regexprep(num2str(anElem),'\s+',','),whichFold,'UniformOutput',false));

matchingEdges=[];
matchingClasses=[];
for(foldIndx=1:numFolds)
% for(foldIndx=1:1)
    disp(['====================================================\n fold # ',num2str(foldIndx),' / ',num2str(numFolds),'\n']);
    thisFold=folds{foldIndx};
    thisY=y(thisFold,:);
    thisClusters=cutoffCls(thisFold,:);
    
    %% filtering clusters which are too small
clsSizes=arrayfun(@(x) sum(cutoffCls==x),unique(cutoffCls));
%     clsSizes=arrayfun(@(x) sum(thisClusters==x),unique(thisClusters));
    dropCls=find(clsSizes<=(size(y,1)/max(cutoffCls)*filterFactor));
%     dropCls=clsSizes<=0; %disable
    surviveMask=~ismember(thisClusters,dropCls);
    
    filteredY=thisY(surviveMask,:);
    filteredCls=thisClusters(surviveMask);
    
    plotGraphPlus([],thisY,[],[],surviveMask,[],[]);

    %% cluster-pairing
    % use all pairs for now.
    [liveCls,~,revCls]=unique(filteredCls);
    rawPairs=genPairs(length(liveCls));
    clsPairs=liveCls(rawPairs);
    if(size(rawPairs)==[1,2])
        clsPairs=clsPairs';
    end

    %% perform the matching.
    distConn=allDistBetweenClusters(clsPairs,filteredCls,filteredY);
    thisMatching=clusterHungarian(clsPairs,distConn);
    [thisMatchingEdges,matchingCls,~]=accumulateMunkresMatch(filteredCls,filteredY,thisMatching);
    
    %% de-pair
    % nothing to do when not altering clusters.
    
    %% de-filter.
    %filteredCls are original digits. Nothing to do.
    %need to undo y changes.
    foldIndxs=find(surviveMask);
    
    %% undo the fold re-ordering.
    matchingEdgesUniv=thisFold(foldIndxs(thisMatchingEdges(:,1:2)));
    if(size(thisMatchingEdges)==[1,3])
        matchingEdgesUniv=matchingEdgesUniv';
    end
    dists=sqrt(sum((y(matchingEdgesUniv(:,1),:)-y(matchingEdgesUniv(:,2),:)).^2,2));
    matchingEdgesUnivMat=[matchingEdgesUniv, dists];
    radix=max(cutoffCls)+1;
%     plotGraphPlus([],filteredY,thisMatchingEdges(:,1:2),repmat(radix*thisMatchingEdges(:,1)+thisMatchingEdges(:,2),size(thisMatchingEdges,1),1),filteredCls,[],[]);
%     plotGraphPlus([],y,        matchingEdgesUniv(:,1:2),repmat(radix*matchingEdgesUniv(:,1)+matchingEdgesUniv(:,2),size(thisMatchingEdges,1),1),cutoffCls,[],[]); %should be same.
    
    %% find adjacencies
    fullMST=full(MST);
    bubbleWidth=max(arrayfun(@(cls) max(max(fullMST(cutoffCls==cls,cutoffCls==cls))),unique(cutoffCls)));
    
    toDelPairs=[0,0];
    
    for(indx=1:size(matchingCls,1))
        againstMask= cutoffCls~= matchingCls(indx,1) & cutoffCls ~= matchingCls(indx,2);
        tooSmallToCare= clsSizes < size(y,1)/150;
        tooSmallToCareCls= find(tooSmallToCare);
        tooSmallMask=~ismember(cutoffCls,tooSmallToCareCls);
        againstLoc=y(againstMask & tooSmallMask,:);
        passes=linePassThroughBall(y(matchingEdgesUnivMat(indx,1),:),y(matchingEdgesUnivMat(indx,2),:),againstLoc,bubbleWidth);
        
        if(any(passes)) %then not adjacent
            toDelPairs=union(toDelPairs, [matchingCls(indx,1),matchingCls(indx,2)],'rows');
        end
    end
    
    toDelPairs=setdiff(toDelPairs,[0,0],'rows');
    toDelPairs=[toDelPairs;fliplr(toDelPairs)];
    if(~isempty(toDelPairs))
        toDel=ismember(matchingCls,toDelPairs,'rows');
        matchingEdgesUnivMat(toDel,:)=[];
        matchingEdgesUniv(toDel,:)=[];
        matchingCls(toDel,:)=[];
    end
    
    %%plotting
%     plotGraphPlus([],y,matchingEdgesUniv(:,1:2),repmat(radix*matchingEdgesUniv(:,1)+matchingEdgesUniv(:,2),size(thisMatchingEdges,1),1),cutoffCls,[],[]); %should be same.
    
    %% add to global match
    matchingEdges=[matchingEdges;matchingEdgesUnivMat];
    matchingClasses=[matchingClasses;matchingCls];
end
matchSizes= cell2mat(arrayfun(@(cls1,cls2) [sum(cutoffCls==cls1),sum(cutoffCls==cls2)], clsPairs(:,1),clsPairs(:,2),'UniformOutput',false)); % size of clusters arranged in pairs to align with the occurence in matchingCls. Technically, should align with index going down matching.
matchSizesForFeatMatch= clsSizesGlobal(matchingClasses); % size of clusters for each edge.
matching=[];

figure
colormap('Lines');
plotGraphPlus(gcf(),y,matchingEdges(:,1:2),[],cutoffCls,[],[]);

    %% de-down-sample and bring tmp into a global matching
    % notice that the use of folds insures that nodes are disjoint amongst
    % folds => edges are disjoint amongst folds
%     [matching]=combineMatchFolds(tmp);
%     [matchingEdges,~,matchIndx]=accumulateMunkresMatch(cutoffCls,y,matching);
    
    %% plotting the match and extracting other data.
%     matchSizes=cell2mat(cellfun(@(cls1,cls2) [sum(cutoffCls==cls1),sum(cutoffCls==cls2)], thisMatching(:,1),thisMatching(:,2),'UniformOutput',false));
%     matchSizesForFeatMatch=[matchSizes(matchIndx,1),matchSizes(matchIndx,2)];
