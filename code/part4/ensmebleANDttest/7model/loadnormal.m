clear all
% load('.\data\4_classification\predict\resnet18\normal\lin_db1_75_205_SLFs\resnet18SLFsN.mat')
load('.\4_classification\literatureclassresult\predict\resnet18\normal\lin_db4_75_205\cytoplasmic&membranous_cytoplasmic&membranous&nuclear_nuclear.mat')
PredLabelN = predlabels; WeightN = weights; antibodyIDN = alabels; imN = images'; labelsN = clabels;
save('./SLFs_LBPsliterature.mat','PredLabelN','WeightN','antibodyIDN','imN','labelsN');
clear all
% load('.\data\4_classification\predict\resnet50\normal\lin_db1_75_205_SLFs\resnet50SLFsN.mat')
load('.\4_classification\literatureclassresult\predict\resnet50\normal\lin_db4_75_205\cytoplasmic&membranous_cytoplasmic&membranous&nuclear_nuclear.mat')
load('SLFs_LBPsliterature.mat')
PredLabelN(112:2*111) = predlabels; WeightN(112:2*111,:) = weights; antibodyIDN(112:2*111) = alabels; imN(112:2*111) = images'; labelsN(112:2*111) = clabels;
save('./SLFs_LBPsliterature.mat','PredLabelN','WeightN','antibodyIDN','imN','labelsN');
clear all
% load('.\data\4_classification\predict\googlenet\normal\lin_db1_75_205_SLFs\googlenetSLFsN.mat')
load('.\4_classification\literatureclassresult\predict\googlenet\normal\lin_db4_75_205\cytoplasmic&membranous_cytoplasmic&membranous&nuclear_nuclear.mat')
load('SLFs_LBPsliterature.mat')
PredLabelN(2*111+1:3*111) = predlabels; WeightN(2*111+1:3*111,:) = weights; antibodyIDN(2*111+1:3*111) = alabels; imN(2*111+1:3*111) = images'; labelsN(2*111+1:3*111) = clabels;
save('./SLFs_LBPsliterature.mat','PredLabelN','WeightN','antibodyIDN','imN','labelsN');
clear all
% load('.\data\4_classification\predict\inceptionv3\normal\lin_db1_75_205_SLFs\SLFsinceptionv3N.mat')
load('.\4_classification\literatureclassresult\predict\inceptionv3\normal\lin_db4_75_205\cytoplasmic&membranous_cytoplasmic&membranous&nuclear_nuclear.mat')
load('SLFs_LBPsliterature.mat')
PredLabelN(3*111+1:4*111) = predlabels; WeightN(3*111+1:4*111,:) = weights; antibodyIDN(3*111+1:4*111) = alabels; imN(3*111+1:4*111) = images'; labelsN(3*111+1:4*111) = clabels;
save('./SLFs_LBPsliterature.mat','PredLabelN','WeightN','antibodyIDN','imN','labelsN');
clear all
% load('.\data\4_classification\predict\resnet101\normal\lin_db1_75_205_SLFs\SLFsresnet101N.mat')
load('.\4_classification\literatureclassresult\predict\resnet101\normal\lin_db4_75_205\cytoplasmic&membranous_cytoplasmic&membranous&nuclear_nuclear.mat')
load('SLFs_LBPsliterature.mat')
PredLabelN(4*111+1:5*111) = predlabels; WeightN(4*111+1:5*111,:) = weights; antibodyIDN(4*111+1:5*111) = alabels; imN(4*111+1:5*111) = images'; labelsN(4*111+1:5*111) = clabels;
save('./SLFs_LBPsliterature.mat','PredLabelN','WeightN','antibodyIDN','imN','labelsN');
clear all
% load('.\data\4_classification\predict\densenet201\normal\lin_db1_75_205_SLFs\SLFsdensenet201N.mat')
load('.\4_classification\literatureclassresult\predict\densenet201\normal\lin_db4_75_205\cytoplasmic&membranous_cytoplasmic&membranous&nuclear_nuclear.mat')
load('SLFs_LBPsliterature.mat')
PredLabelN(5*111+1:6*111) = predlabels; WeightN(5*111+1:6*111,:) = weights; antibodyIDN(5*111+1:6*111) = alabels; imN(5*111+1:6*111) = images'; labelsN(5*111+1:6*111) = clabels;
save('./SLFs_LBPsliterature.mat','PredLabelN','WeightN','antibodyIDN','imN','labelsN');