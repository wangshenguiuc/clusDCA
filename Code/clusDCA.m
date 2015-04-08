function [ final_score ] = clusDCA( specie,lx,ly )
%CLUSDCA Summary of this function goes here
%   Detailed explanation goes here

%
% specie='Human';
% dim_num=2500;
%     lx = dlmread(['/srv/data/swang141/swang141/OutputMatrix/NoIsoString',specie,'USX d=',num2str(dim),' us=1 rsp=0.5.txt']);
%     ly = dlmread(['/srv/data/swang141/swang141/OutputMatrix/NoIsoString',specie,'USY d=',num2str(dim),' us=1 rsp=0.8 bp=0.8.txt']);
    
    [nnode dim] = size(lx)
    [nlabel dim] = size(ly)
    
    nfold = 3;
    nrepeat = nfold;
    % D = squareform(pdist(lx,'cosine'));
    
    [label pos_ind neg_ind pos_l neg_l] = readMatrix(['Data/',specie,'Graph/anotation.txt'],nnode,nlabel);
    ntest = floor(nnode/nfold);
    
    rp = randperm(nnode);
    final_score=zeros(nnode,nlabel);
    
    [g1,g2] = textread(['Data/',specie,'Graph/go_namespace.txt'], '%d%d');
    
    npos=zeros(1,nlabel);
    st_d=[1,11,31,101];
    ed_d=[10,30,100,300];
    for i=1:3
        func_t=g1(g2==i);
        for tp=1:4
            fprintf('case %d type %d / 3... \n',i, tp);
            label_tp = label(:,func_t);
            func_tp = func_t;
            for p=1:nrepeat
                st = (p-1)*ntest+1;
                ed = min(nnode,st+ntest-1);
                test_ind = rp(st:ed);
                train_ind = [rp(1:st-1),rp(ed+1:nnode)];
                train_a = label;
                train_a(test_ind,:) = 0;
                for k=1:nlabel
                    npos(k)=nnz(train_a(:,k));
                end
                func_tp=func_t(npos(func_t)>=st_d(tp)*2/3 & npos(func_t)<=ed_d(tp)*2/3);
                label_tp=label(:,func_tp);
                
                fprintf('permutation %d / %d ... \n', p, nrepeat);
                w = embed(train_ind,label_tp,lx,ly(func_tp,:),pos_l(func_tp,:),neg_l(func_tp,:),pos_ind(func_tp,:),neg_ind(func_tp,:));
                %     w = nonlinear_sigmodSgd(a,label,test_ind,train_ind,lx,ly,D,w);
                class_score = lx*w*ly(func_tp,:)';
                final_score(test_ind,func_tp) = class_score(test_ind,:);
                %              [acc_tst avg_auc_tst mac_auc_tst]func=evaluation(final_score(test_ind,:),label_tp(test_ind,:));
                %              fprintf('lr knn acc        fprintf('nonlinear iter=%d\n',it);_test: %f, avg_auc_test: %f, mac_auc_test: %f\n',acc_tst,avg_auc_tst,mac_auc_tst); toc
            end
            %         evaluation(final_score,label);
        end
    end
    fprintf('final evaluation\n');
    evaluation(final_score,label,specie,1);

end

