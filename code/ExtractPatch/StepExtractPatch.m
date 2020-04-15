function didwegt = StepExtractPatch(PathRoot,WritePATH)
% extract patch from whole image,including modeling dataset and two biomarker datasets
% In the modeling dataset, firstly, save the image in the ./Threedataset-whole/modelingdataset/ folder 
% according to the label of each 3000 * 3000 image,The two biomarker data perform the same operation.
% After executing this code, the extracted patch is saved in the .\per image\ folder

net = googlenet ;
inputSize = net.Layers(1).InputSize;
sizePatch = inputSize(1);
load('./part3/pretrainednetworks/matfile/Wbasis.mat');
% PathRoot = '.\data\Threedataset-whole\modelingdataset\';
% PathRoot='.\data\Threedataset-whole\Literaturebiomarkerdataset\normal\'; % cancer
% PathRoot = '.\data\Threedataset-whole\HPAbiomarkerdataset\normal\'; % cancer
list=dir(fullfile(PathRoot));
for i=3:size(list,1)
    sublist=dir([PathRoot '/' list(i).name]);
    writepath = [WritePATH list(i).name '\'];
    % writepath = ['./data/per image/Literaturebiomarkerdataset/normal/' list(i).name '/']; % cancer
    % writepath = ['./data/per image/HPAbiomarkerdataset/normal/' list(i).name '/']; % cancer 
    if ~exist(writepath,'dir')
        mkdir(writepath);
    end
    for j=3:size(sublist,1)
        imagename = sublist(j).name;
        Im = [PathRoot '/' list(i).name '/' imagename];
        I = imread(Im);
        I = CleanBorders(I);
        I_unmixed = linunmix(I,W);
        prot= I_unmixed(:,:,2);
        nuc = I_unmixed(:,:,1);
        radius = (sizePatch-1)/2;
        numPoints =35;
        Region_coord = findPatches(I,prot,nuc,radius,numPoints,[],writepath,imagename);
    end
end
didwegt = 1;