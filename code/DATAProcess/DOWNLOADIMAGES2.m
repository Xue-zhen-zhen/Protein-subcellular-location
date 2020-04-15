function didwegt = DOWNLOADIMAGES2(datatype)

% addpath ./DATAProcess;
if strcmp(datatype,'Modeling dataset')
    Path = ['./part1/data/'];
    load('./DATAProcess/ModelingDataInfo.mat')
    downloadimages(DataInfo,Path,datatype)
elseif strcmp(datatype,'literature dataset')
    Path = ['./part4/data/biomarkerI/'];
    load('/DATAProcess/LiteratureDataInfo.mat')
    downloadimages(DataInfo,Path,datatype)
elseif strcmp(datatype,'HPA dataset')
    Path = ['./part4/data/biomarkerI/'];
    load('/DATAProcess/HPADataInfo.mat')
    downloadimages(DataInfo,Path,datatype)
end

PATH = '.\part1\data\1_images\';
Writepath = '.\part3\pretrainednetworks\data\Threedataset-whole\modelingdataset\';
TOwholesets(PATH,Writepath);

if strcmp(datatype,'literature dataset')
    PATH = '.\part4\data\biomarkerI\1_images\';
    Writepath = '.\part3\pretrainednetworks\data\Threedataset-whole\Literaturebiomarkerdataset\normal\';
    WritepathC = '.\part3\pretrainednetworks\data\Threedataset-whole\Literaturebiomarkerdataset\cancer\';
    TOwholesets(PATH,Writepath);
    TOwholesets_cancerimage(PATH,WritepathC);
elseif strcmp(datatype,'HPA dataset')
    PATH = '.\part4\data\biomarkerI\1_images\';
    Writepath = '.\part3\pretrainednetworks\data\Threedataset-whole\HPAbiomarkerdataset\normal\';
    WritepathC = '.\part3\pretrainednetworks\data\Threedataset-whole\HPAbiomarkerdataset\cancer\';
    TOwholesets(PATH,Writepath);
    TOwholesets_cancerimage(PATH,WritepathC);
end
rmpath ./DATAProcess;

didwegt=1;