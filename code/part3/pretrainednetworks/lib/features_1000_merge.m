function [data,image,label] = features_1000_merge(imdsTrain,imdsValidation,featuresTrain,featuresValidation)
% load('./result/result3/resnet18_35.mat','imdsTrain','imdsValidation');
% load('features.mat');
Traindata = imdsTrain.Files;
Trainlabels = cellstr(imdsTrain.Labels);
Validationdata = imdsValidation.Files;
Validationlabels = cellstr(imdsValidation.Labels);
[m,n]=size(Traindata); [m1,n1]=size(Validationdata);
% t_data=zeros(m+m1,1000);
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
% data = zeros(length(image),1000);
data = zeros(length(image),size(featuresTrain,2));
label = cell(length(image),1);
for j=1:length(image)
    idex = find(strcmp(image0,image(j)));
    idex_data = t_data(idex,:);
    data(j,:)=mean(idex_data);
    idex_label = t_labels(idex);
    label(j,1)=unique(idex_label);
end
    