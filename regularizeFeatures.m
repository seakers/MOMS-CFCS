function subtractFeatures=regularizeFeatures(subtractFeatures)
   %%multiplies features by -1 to make the leading (1st nonzero) element
   %%positive
   %%then groups into identical features and collapses to unique elements
   %%with counts.
   [row, col]=find(subtractFeatures~=0);
   firstNonZeroCol=accumarray(row, col,[],@min,1);
   needFix=logical(subtractFeatures(sub2ind(size(subtractFeatures),1:length(firstNonZeroCol),firstNonZeroCol'))<0); % NEVER FOR LOOP!!!!
   subtractFeatures(needFix,:)=-subtractFeatures(needFix,:);
   