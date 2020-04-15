load('./result/result3/resnet18_35.mat','imdsTrain','imdsValidation');
Validation=imdsValidation.Files;
Train=imdsTrain.Files;
writepath = ['./traindata/'];
imagepath='E:\Deeplearning\Patch_unmix_1\Cytoplasmic&membranous\';
imgDir  = dir([imagepath '*.png']);
for i=1:size(imgDir,1)
    I_n{i,1}=imgDir(i).name;
end
for k=1:size(Train,1)
    index1=strfind(Train{k},'\');
    Im_n=Train{k}(index1(end)+1:end);
    I_path = [imagepath Im_n];
    I = imread(I_path);
    if ~exist([writepath Im_n],'dir')
        imwrite(I,[writepath Im_n]);
    end
end
    