%%performs basic cluster analysis. inputs:
%%y objective space positions
%%varargin{1} radius of ball around which points occupy OBSOLETED
%%varargin{1} MST corresponding to the points y.
%%varargin{2:end} inputs for breaking clusters.
function [Z,matchingEdges,matchSizes,matchSizesForFeatMatch,matching]=clusterAnalysis(y,varargin)
Z=linkage(y,'single','euclidean');

figure
dendrogram(Z,100);
% linkageStats=inconsistent(Z) % outputs statistics relating to inconsistency--the distance of the links relative to the average underneath them (roughly). Col 1, mean heights of all links used, col 2 std dev of all links used, col 3 number of links used, col 4 inconsistency coefficient
% cophnetCorr=cophenet(Z,pdist(y,'euclidean')) % correlation between cophenetic distance (distance in tree) to distances in space. Probably not useful in our interpretation of problem.
% cutoffCls=cluster(Z,'cutoff',varargin{2:end}); % the interesting stuff seems to hapen between 1.1 and 1.2
cutoffCls=cluster(Z,'maxclust',8);
plotGraphPlus([],y,[],[],cutoffCls,[],mat2cell(num2str(cutoffCls),ones(size(cutoffCls,1),1),size(num2str(cutoffCls),2)));

% matching=compareClusters(cutoffCls,y,varargin(1));
matching=compareClustersMatchFirst(cutoffCls,y,varargin{1});

[matchingEdges,~,matchIndx]=accumulateMunkresMatch(cutoffCls,y,matching);
plot([y(matchingEdges(:,1),1),y(matchingEdges(:,2),1)]',[y(matchingEdges(:,1),2),y(matchingEdges(:,2),2)]');

matchSizes=cell2mat(cellfun(@(cls1,cls2) [sum(cutoffCls==cls1),sum(cutoffCls==cls2)], matching(:,1),matching(:,2),'UniformOutput',false));
matchSizesForFeatMatch=[matchSizes(matchIndx,1),matchSizes(matchIndx,2)];