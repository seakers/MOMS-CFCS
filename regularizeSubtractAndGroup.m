function diffsGrouping=regularizeSubtractAndGroup(subtractFeatures, varargin)
   %%assuming features feature vectors of numbers across the rows
   %%multiplies features by -1 to make the leading (1st nonzero) element
   %%positive
   %%then groups into identical features and collapses to unique elements
   %%with counts.
   %%optional argument for a callback to be callled after regularizing the
   %%vectors but before grouping into unique elements (usually for rounding
   %%out numerical errors)
   
   if nargin==2
       postRegularCallback=varargin{1};
   elseif nargin~=1
       error('regularizeSubtractAndGroup takes 1 or 2 parameters');
   end
   
   subtractFeatures=regularizeFeatures(subtractFeatures)

   if nargin==2
       subtractFeatures=postRegularCallback(subtractFeatures);
   end
   
   [uniqFeat, uniqIndxs, invUniqIndxs]=unique(subtractFeatures,'rows');
   numElem=accumarray(invUniqIndxs,1); % number of each unique element. Fascinating function. Can also group into cell arrays (see example).
   diffsGrouping={uniqIndxs, invUniqIndxs, uniqFeat, numElem}; % subtractFeatures[return[1]]->uniqueElements, inverse of <-, unique elements, number of each unique element
   return