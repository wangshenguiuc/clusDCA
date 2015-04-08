function [A, pos_ind, neg_ind, pos_l, neg_l] = readMatrix(anot_network,nnode,nlabel)




[g1,g2] = textread(anot_network, '%d%d');
A = sparse(g1,g2,1,nnode,nlabel);

pos_ind=zeros(nlabel,nnode);
pos_l = zeros(nlabel,1);
neg_ind=zeros(nlabel,nnode);
neg_l = zeros(nlabel,1);
    
for i=1:nlabel
   p = find(A(:,i)==1);
   n = find(A(:,i)==0);
   pos_ind(i,1:length(p)) = p;
   pos_l(i) = length(p);
   neg_ind(i,1:length(n)) = n;
   neg_l(i) = length(n);
end   

end