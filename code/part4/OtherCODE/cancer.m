function [IDlabel_cancer,weight_cancer,predlabels_cancer] = cancer()
load('weights_cancer1.mat','alabels_cancer','images_cancer');
load('biomarker_cancer.mat');
for i=1:size(images_cancer,2)
    idex=strfind(images_cancer{1,i},'\');
    images_cancer{2,i}=images_cancer{1,i}(idex(end)+1:end);
    ind = strfind(data_cancer{i,1},'_'); 
    data_cancer{i,2}=[data_cancer{i,1}(ind(1)+1:end) '.jpg'];
end
for j=1:size(images_cancer,2)
    [m,n] = find(strcmp(images_cancer,data_cancer(j,2)));
    IDlabel_cancer(j,1) = alabels_cancer(n);
end
predlabels_cancer = zeros(size(images_cancer,2),1);
predict_label = cellstr(predict_label_c);
index0 = find(strcmp(predict_label,'Cytoplasmic&membranous'));
index1 = find(strcmp(predict_label,'Cytoplasmic&membranous&nuclear'));
index2 = find(strcmp(predict_label,'Nuclear'));
predlabels_cancer(index0)=1;  predlabels_cancer(index1)=2; predlabels_cancer(index2)=3;