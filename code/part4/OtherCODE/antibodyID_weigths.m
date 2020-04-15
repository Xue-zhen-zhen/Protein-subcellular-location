% load('weights_normal.mat');
% [antibody_id_n ia ic] = unique(alabels);
% for i=1:length(antibody_id_n)
%     ind = find(alabels==antibody_id_n(i));
%     antibodyID_weights_normal(i,:) = mean( weights(ind,:));
% end
% save('./antibodyID_weights_normal.mat','antibodyID_weights_normal','antibody_id_n');


% load('weights_cancer.mat');
% [antibody_id_c ia ic] = unique(alabels);
% for i=1:length(antibody_id_c)
%     ind = find(alabels==antibody_id_c(i));
%     antibodyID_weights_cancer(i,:) = mean( weights(ind,:));
% end
% save('./antibodyID_weights_cancer.mat','antibodyID_weights_cancer','antibody_id_c');

 clear all;
load('weights_cancer1.mat');
load('weights_normal1.mat');
load('ID_Labels.mat','antibody_ids');
m=0;
M=0;
for i=1:length(antibody_ids)
    ind_n = find(alabels_normal == str2num(antibody_ids{i}));
    ind_c = find(alabels_cancer == str2num(antibody_ids{i}));
    x_n = weights_normal(ind_n,1:3);
    y_c = weights_cancer(ind_c,1:3);
    label_n(m+1:m+length(ind_n),1) = predlabels_normal(ind_n);
    label_n(m+1:m+length(ind_n),2) = clabels_normal(ind_n);
    [m,n] = size(label_n);
    label_c(M+1:M+length(ind_c),1) = predlabels_cancer(ind_c);
    label_c(M+1:M+length(ind_c),2) = clabels_cancer(ind_c);
    [M,N] = size(label_c);
    [H(i,1),P(i,1),CI]=ttest2(x_n(:,1),y_c(:,1),0.05);
    [H(i,2),P(i,2),CI]=ttest2(x_n(:,2),y_c(:,2),0.05);
    [H(i,3),P(i,3),CI]=ttest2(x_n(:,3),y_c(:,3),0.05);
end
a=1;
    


    

