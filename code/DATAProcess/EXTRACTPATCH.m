function didwegt = EXTRACTPATCH(datatype)

addpath ./ExtractPatch;
if  strcmp(datatype,'Modeling dataset')
    PathRoot = '.\part3\pretrainednetworks\data\Threedataset-whole\modelingdataset\';
    WritePath = '.\part3\pretrainednetworks\data\per image\modelingdataset\';
    StepExtractPatch(PathRoot,WritePath)
elseif strcmp(datatype,'literature dataset')
    PathRoot_N = '.\part3\pretrainednetworks\data\Threedataset-whole\Literaturebiomarkerdataset\normal\';
    PathRoot_C = '.\part3\pretrainednetworks\data\Threedataset-whole\Literaturebiomarkerdataset\cancer\';
    WritePath_N = '.\part3\pretrainednetworks\data\ALLpatches\literdataset\normal\';
    WritePath_C = '.\part3\pretrainednetworks\data\ALLpatches\literdataset\cancer\';
    StepExtractPatch(PathRoot_N,WritePath_N)
    StepExtractPatch(PathRoot_C,WritePath_C )
elseif strcmp(datatype,'HPA dataset')
    PathRoot_N = '.\part3\pretrainednetworks\data\Threedataset-whole\HPAbiomarkerdataset\normal\';
    PathRoot_C = '.\part3\pretrainednetworks\data\Threedataset-whole\HPAbiomarkerdataset\cancer\';
    WritePath_N = '.\part3\pretrainednetworks\data\ALLpatches\HPAdataset\normal\';
    WritePath_C = '.\part3\pretrainednetworks\data\ALLpatches\HPAdataset\cancer\';
    StepExtractPatch(PathRoot_N,WritePath_N)
    StepExtractPatch(PathRoot_C,WritePath_C )
end
rmpath ./ExtractPatch;

addpath ./Dataperproteinsplit;
if  strcmp(datatype,'Modeling dataset')
    readPath = '.\part3\pretrainednetworks\data\per image\modelingdataset\';
    list=dir(fullfile(readPath));
    for r=3:size(list,1)
        sublist=dir([readPath '\' list(r).name]);
        writepath = ['.\part3\pretrainednetworks\data\ALLpatches\modelingdataset\'];
        for q=3:length(sublist)
            ImAge = sublist(q).name;
            WritePATH = [writepath ImAge];
            if ~exist(WritePATH,'file')
                I = imread([sublist(q).folder '\' sublist(q).name]);
                imwrite(I,WritePATH);
            end
        end
    end
end

if  strcmp(datatype,'Modeling dataset')
    PathRoot = '.\part1\data\1_images\';
    imagepath='.\part3\pretrainednetworks\data\ALLpatches\modelingdataset\';
    Wpath = '.\part3\pretrainednetworks\data\per protein\modelingdataset\dataTrain\';
    Wtestpath = '.\part3\pretrainednetworks\data\per protein\modelingdataset\dataTest\';
    perproteinSPliteDataMain(PathRoot,imagepath,Wpath,Wtestpath,'normal');
% elseif  strcmp(datatype,'literature dataset')
%     PathRoot = '.\part4\data\biomarkerI\1_images\';
%     imagepath_N='.\part3\pretrainednetworks\data\ALLpatches\literdataset\normal\';
%     imagepath_C='.\part3\pretrainednetworks\data\ALLpatches\literdataset\cancer\';
%     Wpath_N = '.\part3\pretrainednetworks\data\per protein\Literaturebiomarkerdataset\normal\dataTrain\';
%     Wpath_C = '.\part3\pretrainednetworks\data\per protein\Literaturebiomarkerdataset\cancer\dataTrain\';
%     Wtestpath_N = '.\part3\pretrainednetworks\data\per protein\Literaturebiomarkerdataset\normal\dataTest\';
%     Wtestpath_C = '.\part3\pretrainednetworks\data\per protein\Literaturebiomarkerdataset\cancer\dataTest\';
%     perproteinSPliteDataMain(PathRoot,imagepath_N,Wpath_N,Wtestpath_N,'normal');
%     perproteinSPliteDataMain(PathRoot,imagepath_C,Wpath_C,Wtestpath_C,'cancer');
% elseif strcmp(datatype,'HPA dataset')
%     PathRoot = '.\part1\data\biomarkerII\1_images\';
%     imagepath_N='.\part3\pretrainednetworks\data\ALLpatches\HPAdataset\normal\';
%     imagepath_C='.\part3\pretrainednetworks\data\ALLpatches\HPAdataset\cancer\';
%     Wpath_N = '.\part3\pretrainednetworks\data\per protein\HPAbiomarkerdataset\normal\dataTrain\';
%     Wpath_C = '.\part3\pretrainednetworks\data\per protein\HPAbiomarkerdataset\cancer\dataTrain\';
%     Wtestpath_N = '.\part3\pretrainednetworks\data\per protein\HPAbiomarkerdataset\normal\dataTest\';
%     Wtestpath_C = '.\part3\pretrainednetworks\data\per protein\HPAbiomarkerdataset\cancer\dataTest\';
%     perproteinSPliteDataMain(PathRoot,imagepath_N,Wpath_N,Wtestpath_N,'normal');
%     perproteinSPliteDataMain(PathRoot,imagepath_C,Wpath_C,Wtestpath_C,'cancer');
end

didwegt = 1;