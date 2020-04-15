% load('E:\Deeplearning\result\result3\googlenet_35.mat')
imagepath='./Patch_unmix/';
imgDir  = dir([imagepath '*.png']);
imdsTrain = imageDatastore('./perproteinData/perprotein/data/dataTrain',...
            'IncludeSubfolders',true); 
imdsValidation = imageDatastore('./perproteinData/perprotein/data/dataTest',...
            'IncludeSubfolders',true);   
Validation=imdsValidation.Files;
Train=imdsTrain.Files;
for i=1:size(imgDir,1)
    I_n{i,1}=imgDir(i).name;
end
for j=1:size(I_n,1)
    pname=I_n{j};
    index=strfind(I_n{j},')');
    I_n{j,2}=[pname(1:index) pname(end-3:end)];
    I_n{j,3}=[pname(index+2:end-4)];
end
for k=1:size(Validation,1)
    index1=strfind(Validation{k},'\');
    Im_n{k,1}=Validation{k}(index1(end)+1:end);
end
for g=1:size(Validation,1)
    idx = find(strcmp(I_n(:,2),Im_n{g}));
    Im_n{g,2}=I_n(idx,3);
end
Im_n(1:1540,3)=cellstr('Cytoplasmic&membranous');
Im_n(1541:2205,3)=cellstr('Cytoplasmic&membranous&nuclear');
Im_n(2206:end,3)=cellstr('nuclear');
Im_n(:,1)=[];
T=cell2table(Im_n);
writetable(T,'labels_val.txt','WriteVariableNames',0);