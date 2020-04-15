
%%
clear all;clc
datatype  = {'Modeling dataset'}; 
%  datatype = 'Modeling dataset' or 'literature dataset' or 'HPA dataset'


%%
% 1、run DownloadThreeDataset.m to download image.
% if the dataset already exists in the corresponding folder, you can ignore this step.


%%
% 2、 Work on the whole image in Modeling dataset to extract SLFs、SLFs_LBP features under LIN and NMF.
% For this part, please run WholeMain.m alone under the ./part1/ folder

%%
% 3、 Work on extract patch from a whole IHC image in Modeling dataset to extract SLFs、SLFs_LBP features
%  under LIN. For this part, please run PatchmethodMain.m under the ./part2/ folder
%  In PatchmethodMain.m file, please set the runcondation is to 'OnlyExtractPatchfeat'.

%%
% 4、 Pre-trained network
% GapNet-PL is a python file, please see in the ./part3/GapNet-pl/ folder.
SplitMethod = {'per image','per protein'};
NetworkType = {'resent18','resent50','densenet201','googlenet','inceptionv3','resnet101'};
addpath ./PatchDL;
%%%
if strcmp(datatype,'Modeling dataset')
    for i=1:length(SplitMethod)
        for j=1:length(NetworkType)
            LoadNetwork = NetworkType{j};
            classifyMethod = SplitMethod{i};
            didwegt = pretrainedNetworkMain(LoadNetwork,classifyMethod);
        end
    end
end
%%%
if strcmp(datatype,'Modeling dataset')
    for i=1:length(SplitMethod)
        for j=1:length(NetworkType)
            LoadNetwork = NetworkType{j};
            classifyMethod = SplitMethod{i};
            path1 = '.\part3\pretrainednetworks\data\';
            path2 = 'modelingdataset\';
            path3 = '';
            didwegt = DeepFeat1000Main(path1,path2,path3,LoadNetwork,classifyMethod);
        end
    end
elseif strcmp(datatype,'literature dataset')
    for j=1:length(NetworkType)
        LoadNetwork = NetworkType{j};
        path1 = '.\part3\pretrainednetworks\data\ALLpatches\literdataset\';
        path2 = 'normal';
        path3 = 'cancer';
        didwegt = ExtractBiomarkerFeat1000(path1,path2,path3,LoadNetwork,datatype);
    end
elseif strcmp(datatype,'HPA dataset')
    for j=1:length(NetworkType)
        LoadNetwork = NetworkType{j};
        path1 = '.\part3\pretrainednetworks\data\ALLpatches\HPAdataset\';
        path2 = 'normal';
        path3 = 'cancer';
        didwegt = ExtractBiomarkerFeat1000(path1,path2,path3,LoadNetwork,datatype);
    end
end

%%
% 5、 combined SLFs+LBP and pre-trained network features on Modeling dataset
% For this part, please run PatchmethodMain.m under the ./part2/ folder
% before run PatchmethodMain.m, please set the runcondation is to 'CombinedSLFs_LBPandDeepfeat'.


%%
% 6、predict in two biomarker dataset
% This part is to use the trained model for the verification of two biomarker datasets
% In literature dataset, please set the Twobiomarkerdataset is to 'literaturedata', then run biomarkerMain.m file.
% 
% In HPA dataset, please set the Twobiomarkerdataset is to 'HPAdata', then run biomarkerMain.m file.
% 

