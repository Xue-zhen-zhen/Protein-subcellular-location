function [IDlabel_normal,weight_normal,predlabels_normal] = normal()
load('weights_normal1.mat','alabels_normal','images_normal');
load('./biomarker_normal.mat');
for i=1:size(images_normal,2)
    idex=strfind(images_normal{1,i},'\');
    images_normal{2,i}=images_normal{1,i}(idex(end)+1:end);
    ind = strfind(data_normal{i,1},'_'); 
    data_normal{i,2}=[data_normal{i,1}(ind(1)+1:end) '.jpg'];
end
for j=1:size(images_normal,2)
    [m,n] = find(strcmp(images_normal,data_normal(j,2)));
    IDlabel_normal(j,1) = alabels_normal(n);
end
predlabels_normal = zeros(size(images_normal,2),1);
predict_label = cellstr(predict_label_n);
index0 = find(strcmp(predict_label,'Cytoplasmic&membranous'));
index1 = find(strcmp(predict_label,'Cytoplasmic&membranous&nuclear'));
index2 = find(strcmp(predict_label,'Nuclear'));
predlabels_normal(index0)=1;  predlabels_normal(index1)=2; predlabels_normal(index2)=3;
