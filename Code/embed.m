function w= embed(train_ind,A,LX,LY,pos_l,neg_l,pos_ind,neg_ind)
    nlabel = size(LY,1);
    nnode = size(LX,1);
    
    
    xy=zeros(nnode,nlabel);
    
    for i=1:nlabel
%         p = intersect(pos_ind(i,1:pos_l(i)),train_ind);
%         n = intersect(neg_ind(i,1:neg_l(i)),train_ind);
        p = intersect(find(A(:,i)==1),train_ind);
        n = intersect(find(A(:,i)==0),train_ind);
        xy(p,i)=length(n);
        xy(n,i)=-length(p);
    end
    
    w = LX'*xy*LY;
end