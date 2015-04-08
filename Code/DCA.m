function [ final_score ] = DCA( specie,lx,ly )
%DCA Summary of this function goes here
%   Detailed explanation goes here
%
% specie='Human';
% dim=2500;
% lx = dlmread(['/srv/data/swang141/swang141/OutputMatrix/NoIsoString',specie,'USX d=',num2str(dim),' us=1 rsp=0.5.txt']);
% ly = dlmread(['/srv/data/swang141/swang141/OutputMatrix/NoIsoString',specie,'USY d=',num2str(dim),' us=1 rsp=0.8 bp=0.8.txt']);
[nnode dim] = size(lx);
[nlabel dim] = size(ly);

nfold = 3;
nrepeat = nfold;
D = squareform(pdist(lx,'cosine'));

[label pos_ind neg_ind pos_l neg_l] = readMatrix(['Data/',specie,'Graph/anotation.txt'],nnode,nlabel);

% 
size(label)


ntest = floor(nnode/nfold);
rp = randperm(nnode);

final_score=zeros(nnode,nlabel); tic

npos=zeros(1,nlabel);
for p=1:nrepeat
    st = (p-1)*ntest+1;
    ed = min(nnode,st+ntest-1);
    test_ind = rp(st:ed);
    train_ind = [rp(1:st-1),rp(ed+1:nnode)];
    train_a = label;
    train_a(test_ind,:) = 0;
    fprintf('permutation %d / %d ... \n', p, nrepeat);
    class_score = knn(label,test_ind,train_ind,D);
    final_score(test_ind,:) = class_score(test_ind,:); %f\n',acc_tst,avg_auc_tst,mac_auc_tst); toc
end
evaluation(final_score,label,specie,1);



end

