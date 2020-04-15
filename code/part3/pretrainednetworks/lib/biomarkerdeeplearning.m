% imds = imageDatastore('./Patch_biomarker/biomarkerdata2/normal', ...
%     'IncludeSubfolders',true, ...
%     'LabelSource','foldernames'); 
imds = imageDatastore('./Patch_biomarker/biomarkerdata2/cancer', ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames'); 
net0 = densenet201;
inputSize = net0.Layers(1).InputSize;
pixelRange = [-30 30];
scaleRange = [0.9 1.1];
imageAugmenter = imageDataAugmenter( ...
    'RandXReflection',true, ...
    'RandXTranslation',pixelRange, ...
    'RandYTranslation',pixelRange, ...
    'RandXScale',scaleRange, ...
    'RandYScale',scaleRange);
augimds = augmentedImageDatastore(inputSize(1:2),imds, ...
    'DataAugmentation',imageAugmenter);
load('./result/pretrain-model/finallyresult-perimage/result3/densenet201_35.mat','net','options');

% [YPred_normal,probs_normal] = classify(net,augimds);
[YPred_cancer,probs_cancer] = classify(net,augimds);

YLabel = imds.Labels;
% [accuracy_whole,accuracy_test_whole,precision_whole ,data_normal, weight_normal]=merge_whole_Weight(imds,YLabel,YPred_normal,probs_normal);
% save('./result/biomarkerresult/biomarker2result/biomarker_normal.mat','YPred_normal','probs_normal','YLabel','weight_normal','imds')

[accuracy_whole,accuracy_test_whole,precision_whole ,data_cancer, weight_cancer]=merge_whole_Weight(imds,YLabel,YPred_cancer,probs_cancer);
save('./result/biomarkerresult/biomarker2result/biomarker_cancer.mat','YPred_cancer','probs_cancer','YLabel','weight_cancer','imds')
