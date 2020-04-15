function didwegt = perproteinSPliteDataMain(PathRoot,imagepath,Wpath,Wtestpath,condation)
% This part is used to divide all extracted patches into data sets according
% to the per protein division method. 
%

% PathRoot = '.\part1\data\1_images\part1\data\1_images\';
% % list=dir(fullfile(PathRoot));
% imagepath='.\part3\pretrainednetworks\data\ALLpatches\';
imgDir  = dir([imagepath '*.png']);
imgDir = struct2cell(imgDir)';
I_name = imgDir(:,1);
for j=1:length(I_name)
    index = strfind(I_name{j},'_');
    In{j,1} = [I_name{j}(1:index(end)-1) '.jpg'];
end
% Wpath = './perprotein/data/dataTrain/';
% Wtestpath = './perprotein/data/dataTest/';
% [TrainID,TestID] = DLperproteinsplit();
load('splitdata_protein.mat');
% save('./splitdata_protein.mat','TrainID','TestID');
for i=1:size(TrainID,1)
    labelID = TrainID(i,2);
    writepath = [Wpath num2str(labelID) '/'];
    if ~exist(writepath,'dir')
        mkdir(writepath)
    end
    ProtID = TrainID(i,1);
    if strcmp(condation,'normal')
        protpath = [PathRoot num2str(ProtID) '\normal\colon\'];
    elseif strcmp(condation,'cancer')
        protpath = [PathRoot num2str(ProtID) '\cancer\colorectal cancer\'];
    end
    Img  = dir([protpath '*.jpg']);
    H = struct2cell(Img)';
    H = H(:,1);
    for k=1:length(H)
        idex = find(strcmp(In,H(k)));
        Image = I_name(idex);
        for g=1:length(Image)
            IMpath = [imagepath Image{g}];
            I = imread(IMpath);
            if exist([writepath Image{g}],'file')
                continue
            else
                imwrite(I,[writepath Image{g}]);
            end
        end
    end
end
num = proteintestdata(Wtestpath,TestID,PathRoot,In,I_name,imagepath,condation);
didwegt = 1;