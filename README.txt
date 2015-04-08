The code is written in MATLAB. 
A sample yeast dataset is available at http://web.engr.illinois.edu/~swang141/Data/
We first index genes and GO labels with positive integer numbers. And we construct network data files and annotation files. For example, for yeast STRING networks and GO ontology:

---- MolecularNet1.txt ~ MolecularNet6.txt include 6 different yeast networks in STRING.

Format:
202	2173	0.588
2173	202	0.588
204	901	0.001
901	204	0.001
...

In each network file,  every row contains three numbers representing one edge in the network. The first two numbers are the gene id and the last number is the edge weight. 

---- GO.txt includes the edges in the GO ontology graph. 
Format:
1	2
3	4
...
Each row contains two integer numbers representing one directed edge from the first GO label to the second GO label.

We also include file GO_type.txt to annotate types of GO labels. 

Format:
1487	2
3713	2
4201	2
...

The first number is the GO label id, and the second number {1,2 or 3} indicates the type of the label. (1: MF, 2: BP, 3: CC)

---- AnnotationAllNode.txt includes gene GO annotations.

Format:
1024	1
5632	2
...
Each row is a pair of two integer numbers. The first number is a gene id, and the second number is a GO label id which is assigned to the gene. 
