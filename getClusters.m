%%works through the sortedMST (see runSingleHACanalysis) linking objects
%%with indicies given in links1 & 2 (the order of elements in sortMST,
%%links1, links2 is defined by thr ordering of ditances when linking for
%%Single linkage clustering). Gives the clusters as numbers 1-#clusters at
%%each step in the linking process. Observe, that cluster numbers can
%%change in absentia of merging to maintain the sequential property of the
%%numbering.
function clusters=getClusters(sortMST,links1,links2)
numSteps=size(sortMST,1);
clusters=repmat([1:numSteps+1]',1,numSteps+1);

% step through merges and find cluster numbers
for indx=1:numSteps
    prevClusterNum1=clusters(links1(indx),indx);
    prevClusterNum2=clusters(links2(indx),indx);

    % by using the lower number as the new cluster nuumber we remove a
    % number with each step. By tracking the max number cluster we garantee
    % the elimination of the high values sequentially and hence get no
    % holes
    highCluster=clusters(indx)==indx;
    if(prevClusterNum1<prevClusterNum2)
        prevCluster2=clusters(:,indx)==prevClusterNum2;
        clusters(prevCluster2,(indx+1):end)=prevClusterNum1;
        clusters(highCluster,(indx+1):end)=prevClusterNum2;
    else
        prevCluster1=clusters(:,indx)==prevClusterNum1;
        clusters(prevCluster1,(indx+1):end)=prevClusterNum2;
        clusters(highCluster,(indx+1):end)=prevClusterNum1;
    end
end