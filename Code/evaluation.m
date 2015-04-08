% Evaluate prediction performance.
%
% [Input]
% class_score: (# test case) x (# class) matrix of predicted class scores.
%              Higher number represents higher confidence.
% label: (# test case) x (# class) matrix of ground truth annotations.
%        Note each case can have multiple labels
%
% [Output]
% acc: accuracy measure. Pick top prediction for each test case and
%      see how often it matches with one of the true labels.
% f1: micro-averaged F1-score. Pick top alpha predictions for each test case,
%     calculate the contigency table for each class, sum up the table across
%     all classes then calculate the F1-score.
%
function [] = evaluation(class_score, label,specie,bias)
% alpha = 3;
%
% label = label > 0;
%
% [ncase nclass] = size(class_score)
%
% [~,o] = sort(class_score, 2, 'descend');
% p = sub2ind(size(label), (1:ncase)', o(:,1));
% acc = mean(label(p));
%   a = repmat((1:ncase)', 1, alpha);
%   pred = sparse(a, o(:,1:alpha), 1, size(label, 1), size(label, 2));
[g1,g2] = textread(['Data/',specie,'Graph/go_namespace.txt'], '%d%d');
nlabel = size(label,2);
nnode=size(label,2);
npos=zeros(1,nlabel);
st=[3,11,31,101,3];
ed=[10,30,100,300,300];
for i=1:nlabel
    npos(i)=nnz(label(:,i));
end

% for i=1:nnode
%     class_score(i,:) = class_score(i,:) - max(class_score(i,:));
% end
for i=1:3
    func_t=g1(g2==i);
    for j=1:4
        cat=func_t(npos(func_t)>=st(j) & npos(func_t)<=ed(j));
        cat = cat';
        count = 0;
%         ap = 0;
%         apc = 0;
        mac_auc_l=[];
        mac_auc=0;
%         ap_l=[];
        for k=cat            
            auc = calcROCarea(class_score(:,k),label(:,k));
%             [Xpr,Ypr,Tpr,prec] = perfcurve(label(:,k), class_score(:,k), 1, 'xCrit', 'reca', 'yCrit', 'prec');
%             if ~isnan(prec)
%                 ap = ap + prec;
%                 apc = apc + 1;
%                 ap_l=[ap_l,prec];
%             end
            if ~isnan(auc)
                count = count + 1;
                mac_auc = mac_auc + auc;
                mac_auc_l=[mac_auc_l,auc];
            end
            if bias==1
                class_score(:,k) = class_score(:,k)-mean(class_score(:,k));
            end            
        end
        s=class_score(:,cat);
        s=s(:);
        l=label(:,cat);
        l=l(:);
        mic_auc = calcROCarea(s,l);
%         [~,~,~,micprec] = perfcurve(l, s, 1, 'xCrit', 'reca', 'yCrit', 'prec');
%         micprec=0;
        fprintf('type=%d\tcat=%d\tmacro AUC=%f\tstd(macro AUC)=%f\tmicro AUC=%f\tcount=%d\n',i,j,mac_auc/count,std(mac_auc_l),mic_auc,length(cat));
        
    end
    
end

end
