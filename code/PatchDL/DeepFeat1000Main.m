function  didwegt = DeepFeat1000Main(path1,path2,path3,LoadNetwork,classifyMethod)

%the code is based on the official Mathworks toolbox:
%https://ww2.mathworks.cn/help/deeplearning/examples/extract-image-features-using-pretrained-network.html

addpath ./lib
addpath ./othercode
PerimagePath = [path1 'per image\' path2 path3];
PerproteinPath = [path1 'per protein\' path2 path3];

if strcmp(classifyMethod,'per image')
    imds = imageDatastore(PerimagePath, ...
        'IncludeSubfolders',true, ...
        'LabelSource','foldernames');  % per protein
    [imdsTrain,imdsValidation] = splitEachLabel(imds,0.9,'randomized');
    
elseif strcmp(classifyMethod,'per protein')
    imdsTrain = imageDatastore([PerproteinPath 'dataTrain\'],...
        'IncludeSubfolders',true ,...
        'LabelSource','foldernames');
    imdsValidation = imageDatastore([PerproteinPath 'dataTest\'],...
        'IncludeSubfolders',true,...
        'LabelSource','foldernames');
end

%load a pretrained network, inception v3,googlenet,resnet50,resnet101,densenet201,
if strcmp(LoadNetwork,'GapNet-PL')
    if strcmp(classifyMethod,'per image')
        featuresTrain = importdata('.\part2\networkfeatures\modelingdataset\perimage\traindata.txt');
        featuresValidation = importdata('.\part2\networkfeatures\modelingdataset\perimage\validationdata.txt');
    elseif strcmp(classifyMethod,'per protein')
        featuresTrain = importdata('.\part2\networkfeatures\modelingdataset\perprotein\traindata.txt');
        featuresValidation = importdata('.\part2\networkfeatures\modelingdataset\perprotein\validationdata.txt');
    end
else
    switch LoadNetwork
        case 'resent18'
            net = resnet18;
            layer = 'fc1000';
        case 'resent50'
            net = resnet50;
            layer = 'fc1000';
        case 'densenet201'
            net = densenet201;
            layer = 'fc1000';
        case 'googlenet'
            net = googlenet;
            layer = 'loss3-classifier';
        case 'inceptionv3'
            net = inceptionv3;
            layer = 'predictions';
        case 'resnet101'
            net = resnet101;
            layer = 'fc1000';
        otherwise
    end
    inputSize = net.Layers(1).InputSize;
    pixelRange = [-30 30];
    scaleRange = [0.9 1.1];
    imageAugmenter = imageDataAugmenter( ...
        'RandXReflection',true, ...
        'RandXTranslation',pixelRange, ...
        'RandYTranslation',pixelRange, ...
        'RandXScale',scaleRange, ...
        'RandYScale',scaleRange);
    augimdsTrain = augmentedImageDatastore(inputSize(1:2),imdsTrain, ...
        'DataAugmentation',imageAugmenter);
    augimdsValidation = augmentedImageDatastore(inputSize(1:2),imdsValidation);
    
    featuresTrain = activations(net,augimdsTrain,layer,'OutputAs','rows');
    featuresValidation = activations(net,augimdsValidation,layer,'OutputAs','rows');
end
% pretrainmodel

%% labels
YTrain = cellstr(imdsTrain.Labels);
YValidation = cellstr(imdsValidation.Labels);
ind0_YT = find(strcmp(YTrain,'Cytoplasmic&membranous')); ind0_YV = find(strcmp(YValidation,'Cytoplasmic&membranous'));
ind1_YT = find(strcmp(YTrain,'Cytoplasmic&membranous&nuclear')); ind1_YV = find(strcmp(YValidation,'Cytoplasmic&membranous&nuclear'));
ind2_YT = find(strcmp(YTrain,'Nuclear'));  ind2_YV = find(strcmp(YValidation,'Nuclear'));
trainlabels =zeros(length(YTrain),1);
Vlabels = zeros(length(YValidation),1);
trainlabels(ind0_YT,1)=1; trainlabels(ind1_YT,1)=2; trainlabels(ind2_YT,1)=3;
Vlabels(ind0_YV,1)=1; Vlabels(ind1_YV,1)=2; Vlabels(ind2_YV,1)=3;

%% Feature selection by SDA
[traindata,validationdata] = featnorm(featuresTrain,featuresValidation);
traindata = double(traindata*2-1);
validationdata = double(validationdata*2-1);
u = unique(trainlabels);
feat = []; feat{length(u)} = [];
for i=1:length(u)
    feat{i} = traindata( trainlabels==u(i),:);
end
idx_sda = ml_stepdisc(feat);

%% patch SVM classification
% [model,options] = trainClassifier( trainlabels,traindata(:,idx_sda));%
% [predlabels,accuracy,weights] = svmpredict( Vlabels,validationdata(:,idx_sda), model,'-b 1');
% %patch accuracy
% % [accuracy_test_patch,recall_patch,precision_patch ,F1_score_patch] = evaluate(predlabels,Vlabels);
%
% % patch merge whole image
% key0 = find(predlabels==1); key1 = find(predlabels==2);  key2 = find(predlabels==3);
% YPred = cell(length(predlabels),1);
% YPred(key0) = cellstr('Cytoplasmic&membranous');
% YPred(key1) = cellstr('Cytoplasmic&membranous&nuclear');
% YPred(key3) = cellstr('Nuclear');
% YPred = categorical(YPred);
% [accuracy_whole,accuracy_test_whole,recall_whole,precision_whole ,F1_score_whole]=patch_merge_whole(imdsValidation,imdsValidation.Labels,YPred);

%% whole image classification
[data,image,label] = features_1000_merge(imdsTrain,imdsValidation,featuresTrain,featuresValidation);
% [alabels] = IDlabels(image); %  perprotein class
num0 = find(strcmp(label,'Cytoplasmic&membranous'));
num1 = find(strcmp(label,'Cytoplasmic&membranous&nuclear'));
num2 = find(strcmp(label,'Nuclear'));
clabels = zeros(length(label),1);
clabels(num0,1)=1; clabels(num1,1)=2; clabels(num2,1)=3;
[mean_per_evalmodel,indices]=ten_foldValidation(data,clabels,idx_sda);  %  perprotein class,alabels

if strcmp(classifyMethod,'per image')
    save(['./result/1000result/' path2 'perimage/' path3 '/' LoadNetwork '.mat'],'data','clabels',...
        'idx_sda','featuresTrain',...
        'featuresValidation','mean_per_evalmodel','imdsTrain','imdsValidation','indices','image');
    save(['.\part2\networkfeatures\modelingdataset\perimage\' LoadNetwork '.mat'],'data','clabels',...
        'idx_sda','featuresTrain',...
        'featuresValidation','mean_per_evalmodel','imdsTrain','imdsValidation','indices','image');
elseif strcmp(classifyMethod,'per protein')
    save(['./result/1000result/' path2 'perprotein/' path3 '/' LoadNetwork '.mat'],'data','clabels',...
        'idx_sda','featuresTrain',...
        'featuresValidation','mean_per_evalmodel','imdsTrain','imdsValidation','indices','image');
    save(['.\part2\networkfeatures\modelingdataset\perprotein\' LoadNetwork '.mat'],'data','clabels',...
        'idx_sda','featuresTrain',...
        'featuresValidation','mean_per_evalmodel','imdsTrain','imdsValidation','indices','image')
end
didwegt =1;
