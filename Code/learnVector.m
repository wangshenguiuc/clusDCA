function [ USA,USB] = learnVector(specie, d, bp, rspx, rspy,nnode)
% load network data
%
% [Input]
% weight: 0 represents the all the edges have same weight. 1 represents all
% the deges have different weight
% nnode: number of nodes
% bp: back propogation probability
%
% [Output]
% A : the sparse matrix of network.

go_network = ['Data/',specie,'Graph/go.txt'];
% anot_network = ['Data/',specie,'Graph/noisonewAnotation.txt'];

% path = '/srv/data/swang141/';

% rspx = 0.5;
% rspy = 0.8;
% bp = 0.8;
%
%
for i=1:6
    file_name = ['Data/',specie,'Graph/ppi',num2str(i),'.txt'];
    nt = load_network(file_name,true,nnode);
    nnode = size(nt,1);
    tA = run_diffusion(nt, 'personalized-pagerank', struct('maxiter', 20, 'reset_prob', rspx));
    if i==1
        QA = tA;
%         TQA = tA;
        continue
    end
    QA = [QA,tA];
%     TQA = [TQA;tA];
end

% TQA = TQA';
size(QA)
alpha = 1/nnode;
QA = log(QA+alpha)-log(alpha);
% TQA = log(TQA+alpha)-log(alpha);
QA=QA*QA';
size(QA)
% TQA=TQA*TQA';

B = load_network(go_network,false,0,bp);
nlabel=size(B,1);
QB = run_diffusion(B, 'personalized-pagerank', struct('maxiter', 20, 'reset_prob', rspy));
alpha = 1/nlabel;
QB = log(QB+alpha)-log(alpha);



fprintf('run X SVD d=%d\n',d);tic
QA = sparse(QA);
[U,S] = svds(QA,d);
LA = U;
USA = LA*sqrt(sqrt(S));toc

% file_name = [path,'swang141/OutputMatrix/NoIsoStringHumanLX ','d=',num2str(d),' us=',num2str(us),' rsp=',num2str(rspx),'.txt'];
% dlmwrite(file_name, LA);
% file_name = [path,'swang141/OutputMatrix/NoIsoStringHumanUSX ','d=',num2str(d),' us=',num2str(us),' rsp=',num2str(rspx),'.txt'];
% dlmwrite(file_name, USA);
fprintf('run Y SVD d=%d\n',d);tic
[U,S] = svds(QB,d);
LB = U;
USB = LB*sqrt(S);toc
% file_name = [path,'swang141/OutputMatrix/NoIsoStringHumanLY ','d=',num2str(d),' us=',num2str(us),' rsp=',num2str(rspy),' bp=',num2str(bp),'.txt'];
% dlmwrite(file_name, LB);
% file_name = [path,'swang141/OutputMatrix/NoIsoStringHumanVY ','d=',num2str(d),' us=',num2str(us),' rsp=',num2str(rspy),' bp=',num2str(bp),'.txt'];
% dlmwrite(file_name, V);
% file_name = [path,'swang141/OutputMatrix/NoIsoStringHumanUSY ','d=',num2str(d),' us=',num2str(us),' rsp=',num2str(rspy),' bp=',num2str(bp),'.txt'];
% dlmwrite(file_name, USB);
% fprintf('run TX SVD d=%d\n',d);
% TQA = sparse(TQA);
% [U,S] = svds(TQA,d);
% LA = U;toc
% USA = LA*sqrt(sqrt(S));
% 
% file_name = [path,'swang141/OutputMatrix/NoIsoStringHumanTLX ','d=',num2str(d),' us=',num2str(us),' rsp=',num2str(rspx),'.txt'];
% dlmwrite(file_name, LA);
% file_name = [path,'swang141/OutputMatrix/NoIsoStringHumanTUSX ','d=',num2str(d),' us=',num2str(us),' rsp=',num2str(rspx),'.txt'];
% dlmwrite(file_name, USA);


end

