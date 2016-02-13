function [matching]=combineMatchFolds(tmp)
    radix=max(cellfun(@(subcell) max(max(cell2mat(subcell(:,1:2)))),tmp,'UniformOutput',true))+1;
    
    UIDs=cell(size(tmp));
    allUID=[];
    for indx=length(tmp)
        subcell=tmp{indx};
        clsMat=cell2mat(subcell);
%         clsMatSort=sort(clsMat,2);
        clsUID=clsMat*[radix;1];
        allUID=union(allUID,clsUID);
        
        UIDs{indx}=clsUID;
    end
    
    numPairsInFinalMatching=sum(arrayfun(@(thisUID) sum(cellfun(@(subcell) sum(thisUID==subcell)...
                                ,UIDs,'UniformOutput',true)), allUID,'UnformOutput',true));
    matching=cell(numPairsInFinalMatching,3);
    fillLevel=0;
    for UIDindx=length(allUID)
        thisUID=allUID(UIDindx);
        matchSizes=cellfun(@(subcell) sum(thisUID==subcell),UIDs,'UniformOutput',true);
        numMatch=sum(matchSizes);
        
        rightCls=mod(thisUID,radix);
        leftCls=(thisUID-rightCls)/radix;
        for(indx=1:numMatch)
            matching{fillLevel+indx,1}=leftCls;
            matching{fillLevel+indx,2}=rightCls;
        end
        
        holding=nan(numMatch,
        for cellIndx=1:length(UIDs)
            clsPair= allUID(UIDindx)==UIDs{indx};
            
            %% need to account for when indicies swap because folds hve different numbers of elements.
            %% todo, would need to sort when finding UIDs and revrse out effect of assign transforming.
            
            fillLevel=fillLevel+numMatch;