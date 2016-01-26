function summaryTxt=diffsGroupToText(diffsGrouping)
summaryTxt=cell(size(diffsGrouping,1),1);

for i=1:size(summaryTxt,1)
    featSet=diffsGrouping{i,2};
    numFeatSet=size(featSet,1);
    summaryTxtLine=['merges: ',num2str(diffsGrouping{i,1}),' total: ',num2str(sum(diffsGrouping{i,3})),' #featureSets: ', num2str(numFeatSet), ' :: '];
    cnt=diffsGrouping{i,3};
    for j=1:numFeatSet %output feature sets which yield move pattern
        summaryTxtLine=[summaryTxtLine,'(',num2str(featSet(j,:)),' | ',num2str(cnt(j)),') '];
    end
    summaryTxt{i}=summaryTxtLine;
end