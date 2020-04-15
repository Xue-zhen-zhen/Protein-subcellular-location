clear all
% load('.\data\4_classification\predict\resnet18\cancer\lin_db1_75_205_SLFs\resnet18SLFsC.mat')
load('.\4_classification\literatureclassresult\predict\resnet18\cancer\lin_db4_75_205\cytoplasmic&membranous_cytoplasmic&membranous&nuclear_nuclear.mat')
PredLabelC = predlabels; WeightC = weights; antibodyIDC = alabels; imC = images'; labelsC = clabels;
save('./SLFs_LBPsliteratureC.mat','PredLabelC','WeightC','antibodyIDC','imC','labelsC');
clear all
% load('.\data\4_classification\predict\resnet50\cancer\lin_db1_75_205_SLFs\resnet50SLFsC.mat')
load('.\4_classification\literatureclassresult\predict\resnet50\cancer\lin_db4_75_205\cytoplasmic&membranous_cytoplasmic&membranous&nuclear_nuclear.mat')
load('SLFs_LBPsliteratureC.mat')
PredLabelC(660:2*659) = predlabels; WeightC(660:2*659,:) = weights; antibodyIDC(660:2*659) = alabels; imC(660:2*659) = images'; labelsC(660:2*659) = clabels;
save('./SLFs_LBPsliteratureC.mat','PredLabelC','WeightC','antibodyIDC','imC','labelsC');
clear all
% load('.\data\4_classification\predict\googlenet\cancer\lin_db1_75_205_SLFs\googlenetSLFsC.mat')
load('.\4_classification\literatureclassresult\predict\googlenet\cancer\lin_db4_75_205\cytoplasmic&membranous_cytoplasmic&membranous&nuclear_nuclear.mat')
load('SLFs_LBPsliteratureC.mat')
PredLabelC(2*659+1:3*659) = predlabels; WeightC(2*659+1:3*659,:) = weights; antibodyIDC(2*659+1:3*659) = alabels; imC(2*659+1:3*659) = images'; labelsC(2*659+1:3*659) = clabels;
save('./SLFs_LBPsliteratureC.mat','PredLabelC','WeightC','antibodyIDC','imC','labelsC');
clear all
% load('.\data\4_classification\predict\inceptionv3\cancer\lin_db1_75_205_SLFs\SLFsinceptionv3C.mat')
load('.\4_classification\literatureclassresult\predict\inceptionv3\cancer\lin_db4_75_205\cytoplasmic&membranous_cytoplasmic&membranous&nuclear_nuclear.mat')
load('SLFs_LBPsliteratureC.mat')
PredLabelC(3*659+1:4*659) = predlabels; WeightC(3*659+1:4*659,:) = weights; antibodyIDC(3*659+1:4*659) = alabels; imC(3*659+1:4*659) = images'; labelsC(3*659+1:4*659) = clabels;
save('./SLFs_LBPsliteratureC.mat','PredLabelC','WeightC','antibodyIDC','imC','labelsC');
clear all
% load('.\data\4_classification\predict\resnet101\cancer\lin_db1_75_205_SLFs\SLFsresnet101C.mat')
load('.\4_classification\literatureclassresult\predict\resnet101\cancer\lin_db4_75_205\cytoplasmic&membranous_cytoplasmic&membranous&nuclear_nuclear.mat')
load('SLFs_LBPsliteratureC.mat')
PredLabelC(4*659+1:5*659) = predlabels; WeightC(4*659+1:5*659,:) = weights; antibodyIDC(4*659+1:5*659) = alabels; imC(4*659+1:5*659) = images'; labelsC(4*659+1:5*659) = clabels;
save('./SLFs_LBPsliteratureC.mat','PredLabelC','WeightC','antibodyIDC','imC','labelsC');
clear all
% load('.\data\4_classification\predict\densenet201\cancer\lin_db1_75_205_SLFs\SLFsdensenet201C.mat')
load('.\4_classification\literatureclassresult\predict\densenet201\cancer\lin_db4_75_205\cytoplasmic&membranous_cytoplasmic&membranous&nuclear_nuclear.mat')
load('SLFs_LBPsliteratureC.mat')
PredLabelC(5*659+1:6*659) = predlabels; WeightC(5*659+1:6*659,:) = weights; antibodyIDC(5*659+1:6*659) = alabels; imC(5*659+1:6*659) = images'; labelsC(5*659+1:6*659) = clabels;
save('./SLFs_LBPsliteratureC.mat','PredLabelC','WeightC','antibodyIDC','imC','labelsC');