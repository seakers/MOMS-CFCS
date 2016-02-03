%%returns indicies to index the elements of cluster to get the
%%corresponding matching of the elements. that is if idx=1:size(clusters,1)
%%then idx(cls1used)<->indx(cls2used) where <-> refers to the matching from
%%munkres (output munkres to assign input). More fully, the larger class
%%has the elements which are assigned retrieved and the smaller class is
%%permuted. cls1 and cls2 have no size constraints.
function [cls1used, cls2used]=interpretMunkresMatching(clusters, cls1, cls2, assign)
    cls1pts=find(clusters==cls1);
    cls2pts=find(clusters==cls2);
    
    if(length(cls1pts)>length(cls2pts))
        cls1used=cls1pts(assign>0);
        cls2used=cls2pts(assign(assign>0)); %permutes the ordering of class 2 to match class1
    else
        cls2used=cls2pts(assign>0);
        cls1used=cls1pts(assign(assign>0)); %permutes the ordering of class 2 to match class1
    end
return