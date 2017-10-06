% type 1: MF
% type 2: BP
% type 3: CC
% cat 1: 3-10
% cat 2: 11-30
% cat 3: 31-100
% cat 4 101-300

specie='Yeast';
% addpath for your working directory
%path = '/home/swang141/research/BioNetwork/GoPrediction/clusDCA/';
%specie='Yeast';

dim=2500;
rspx = 0.5;
rspy = 0.8;
bp = 0.8;
nnode = 6311;%16662;
nlabel = 4240;%13807;

%16662 node for human, 6311 node for yeast

[lx, ly] = learnVector(specie, dim, bp, rspx, rspy,nnode);
% lx = dlmread(['/srv/data/swang141/swang141/OutputMatrix/NoIsoString',specie,'USX d=',num2str(dim),' us=1 rsp=0.5.txt']);
% ly = dlmread(['/srv/data/swang141/swang141/OutputMatrix/NoIsoString',specie,'USY d=',num2str(dim),' us=1 rsp=0.8 bp=0.8.txt']);
our_score = clusDCA(specie,lx,ly);

%

% dca_score = DCA(specie,lx,ly);

