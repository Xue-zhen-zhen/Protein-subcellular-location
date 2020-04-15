PathRoot = 'E:\MatlabWorks\work1_learnMatlab\data\1_images\';
list=dir(fullfile(PathRoot));
imagepath='./Patch_number/number=35/Cytoplasmic&membranous/';
imgDir  = dir([imagepath '*.png']);
imgDir = struct2cell(imgDir)';
I_name = imgDir(:,1);
for j=1:length(I_name)
    index = strfind(I_name{j},'_');
    In{j,1} = [I_name{j}(1:index(end)-1) '.jpg'];
end
% a=struct2cell(list)';
% ID = a(3:end,1);
% ID = str2num(cell2mat(ID));  
load('ID.mat')
antibodyID = str2num(cell2mat(antibody_ids'));
ind0 = find(strcmp(cellstr(classlabels),'cytoplasmic/membranous'));
ind1 = find(strcmp(cellstr(classlabels),'cytoplasmic/membranous&nuclear'));
ind2 = find(strcmp(cellstr(classlabels),'nuclear'));
antibodyID(ind0,2) = 1; antibodyID(ind1,2) = 2; antibodyID(ind2,2) = 3;
Wpath = './data/dataTrain/';
Wtestpath = './data/dataTest/';
load('./data/splitdata_protein.mat');
% [TrainID,TestID]=divide(antibodyID,0.9);
for i=1:size(TrainID,1)
    labelID = TrainID(i,2);
    writepath = [Wpath num2str(labelID) '/'];
    if ~exist(writepath,'dir')
        mkdir(writepath)
    end
    ProtID = TrainID(i,1);
    protpath = [PathRoot num2str(ProtID) '\normal\colon\'];
    Img  = dir([protpath '*.jpg']);
    H = struct2cell(Img)';
    H = H(:,1);
    for k=1:length(H)
        idex = find(strcmp(In,H(k)));
        Image = I_name(idex);
        for g=1:length(Image)
            IMpath = [imagepath Image{g}];
            I = imread(IMpath);
            if ~exist([writepath Image{g}],'dir')
                imwrite(I,[writepath Image{g}]);
            end
        end
    end              
end
num = proteintestdata(Wtestpath,TestID,PathRoot,In,I_name,imagepath);
% save('./data/splitdata_protein.mat','TrainID','TestID');


function [S,T]=divide(data,rate)
    S = [];
    T = [];
    [m, n] = size(data);
    labels = data(:,n);
    labelsClass = unique(labels);
    weight = [];
    for i=1:length(labelsClass)
        weight(i) = round(sum(ismember(labels,labelsClass(i)))*rate);
    end
    for i=1:length(labelsClass)
        index = find(labels==labelsClass(i));
        randomIndex = index(randperm(length(index)));
        S = [S;data(randomIndex(1:weight(i)),:)];
        T = [T;data(randomIndex(weight(i)+1:sum(ismember(labels,labelsClass(i)))),:)];
    end
end