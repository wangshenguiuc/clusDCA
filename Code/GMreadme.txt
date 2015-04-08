1. We downloaded the matlab code of GeneMania from http://morrislab.med.utoronto.ca/Data/GB08/GB08Suppl.html

2. We used the script "runGeneMANIA.m" to read our input six molecular networks.

3. We then iterated each GO labels and used function "predictClassesCV" to get the score vector of leave-out scores for each gene in the test set (i.e., the score that gene got when it was one of the left out genes)

4. We stored this confidence score vector of test set and used the confidence score matrix of all the GO labels to perform evaluation.