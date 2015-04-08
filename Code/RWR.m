function [ final_score ] = RWR( specie,nnode,nlabel,rspx)
%RWR Summary of this function goes here
%   Detailed explanation goes here
%
% nnode = 6311;
% go_network = ['Data/',specie,'Graph/noisogo.txt'];
% anot_network = ['Data/',specie,'Graph/noisonewAnotation.txt'];
% 
% path = '/srv/data/swang141/';
% 
% num_dim=[1000,1500];
% us= true;
% rspx = 0.5;
% rspy = 0.8;
%
%
base = ones(nnode,nnode);
for i=1:6
    file_name = ['Data/',specie,'Graph/ppi',num2str(i),'.txt'];
    nt = load_network(file_name,true,nnode);
    nt = 1-nt;
    base = base.*nt;
end
base = 1-base;

QA = run_diffusion(base, 'personalized-pagerank', struct('maxiter', 20, 'reset_prob', rspx));



nfold = 3;
nrepeat = nfold;
D = 1-QA;

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
evaluation(final_score,label,specie,0);



end

