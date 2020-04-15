function [predata]=features_1000_merge(predata,preimages,splittype,nettype)
% This file is used to combine the features when the patch selects the optimal parameters 
% and the features extracted by the pre-training network.
% The extracted pre-trained network features must be saved under 
% the file ./networkfeatures/ in the data split method of per image and per protein.

if strcmp( splittype, 'per protein')
    load(['.\networkfeatures\modelingdataset\perprotein\' nettype '.mat'], 'featuresTrain','featuresValidation','imdsTrain','imdsValidation')
end
if strcmp( splittype, 'per image')
    load(['.\networkfeatures\modelingdataset\perimage\' nettype '.mat'],'featuresTrain','featuresValidation','imdsTrain','imdsValidation');
end

featnum = size(featuresTrain,2);
[row,c] = size(predata);
Traindata = imdsTrain.Files;
Trainlabels = cellstr(imdsTrain.Labels);
Validationdata = imdsValidation.Files;
Validationlabels = cellstr(imdsValidation.Labels);
[m,n]=size(Traindata); [m1,n1]=size(Validationdata);

t_data=zeros(m+m1,size(featuresTrain,2));                   t_labels=cell(m+m1,1);                image_n=cell(m+m1,1);
t_data(1:m,:)=featuresTrain;               t_labels(1:m,:)=Trainlabels;          image_n(1:m,:)=Traindata;
t_data(m+1:end,:)=featuresValidation;      t_labels(m+1:end,:)=Validationlabels;  image_n(m+1:end,:)=Validationdata;
for i=1:length(image_n)
    I = image_n{i};
    idex0=strfind(I,'\');
    idex1=strfind(I,'(');
    image0(i,1) = cellstr(I(idex0(end)+1:idex1-2));
end
[image ia ic] = unique(image0);
data = zeros(length(image),size(featuresTrain,2));
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
end