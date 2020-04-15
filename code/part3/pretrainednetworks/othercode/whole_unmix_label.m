% imds = imageDatastore('./ImagesData', ...
%     'IncludeSubfolders',true, ...
%     'LabelSource','foldernames'); 
% [imdsTrain,imdsValidation] = splitEachLabel(imds,0.9,'randomized');
% save('./wholeSplit.mat','imdsTrain','imdsValidation');
load('wholeSplit.mat');
imagepath='./Patch_unmix_whole/';
imgDir  = dir([imagepath '*.jpg']);
Validation=imdsValidation.Files;
Train=imdsTrain.Files;
for i=1:size(imgDir,1)
    I_n{i,1}=imgDir(i).name;
end
for j=1:size(I_n,1)
    pname=I_n{j};
    index=strfind(I_n{j},'(');
    I_n{j,2}=[pname(1:index(end)-2) pname(end-3:end)];
    I_n{j,3}=[pname(index(end)+2:end-4)];
end
for k=1:size(Validation,1)
    index1=strfind(Validation{k},'\');
    Im_n{k,1}=Validation{k}(index1(end)+1:end);
end
for g=1:size(Validation,1)
    idx = find(strcmp(I_n(:,2),Im_n{g}));
    Im_n{g,2}=I_n(idx,3);
end
Im_n(1:50,3)=cellstr('Cytoplasmic&membranous');
Im_n(51:63,3)=cellstr('Cytoplasmic&membranous&nuclear');
Im_n(64:end,3)=cellstr('nuclear');
Im_n(:,1)=[];
T=cell2table(Im_n);
writetable(T,'labels_val.txt','WriteVariableNames',0);