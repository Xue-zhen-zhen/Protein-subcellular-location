function [predata,clabels]=features_1000_merge(predata,preimages,condation,datatype,NetworkType)  
% This file is used to combine the features when the patch selects the optimal parameters 
% and the features extracted by the pre-training network.
% The extracted pre-trained network features must be saved under 
% the file ./biomarkerfeatures/.

% normal condation
if strcmp(condation,'normal')
    if strcmp(datatype,'biomarkerII')
        load(['.\biomarkerfeatures\HPA dataset\' condation '\' NetworkType '.mat'],'featuresN','imds');
    elseif strcmp(datatype,'biomarkerI')
        load(['.\biomarkerfeatures\literature dataset\' condation '\' NetworkType '.mat'],'featuresN','imds');
    end
    t_data = featuresN; t_labels = cellstr(imds.Labels);  image_n = imds.Files;
    featnum = size(featuresN,2);
end

% cancer condation
if strcmp(condation,'cancer')
    if strcmp(datatype,'biomarkerII')
        load(['.\biomarkerfeatures\HPA dataset\' condation '\' NetworkType '.mat'],'featuresC','imdsC');
    elseif strcmp(datatype,'biomarkerI')
        load(['.\biomarkerfeatures\literature dataset\' condation '\' NetworkType '.mat'],'featuresC','imdsC');
    end
    t_data = featuresC; t_labels = cellstr(imdsC.Labels);  image_n = imdsC.Files;
    featnum = size(featuresC,2);
end

[row,c] = size(predata);
for i=1:length(image_n)
    I = image_n{i};
    idex0=strfind(I,'\');
    idex1=strfind(I,'_');
    image0(i,1) = cellstr(I(idex0(end)+1:idex1(end)-1));
end
[image ia ic] = unique(image0);
data = zeros(length(image),featnum);
label = cell(length(image),1);
for j=1:length(image)
    idex = find(strcmp(image0,image(j)));
    idex_data = t_data(idex,:);
    data(j,:)=mean(idex_data);
    idex_label = t_labels(idex);
    label(j,1)=unique(idex_label);
end
for k=1:length(preimages)
    I_n = preimages{k};
    ind=strfind(I_n,'\');
    Image = I_n(ind(end)+1:end-4);
    ind0 = find(strcmp(image,Image));
    predata(k,c+1:c+featnum)=data(ind0,:);
    clabel(k,1) = label(ind0,:);  
end
clabels = zeros(size(predata,1),1);
index0 = find(strcmp(clabel,'Cytoplasmic&membranous'));
index1 = find(strcmp(clabel,'Cytoplasmic&membranous&nuclear'));
index2 = find(strcmp(clabel,'Nuclear'));
clabels(index0)=1;  clabels(index1)=2; clabels(index2)=3;