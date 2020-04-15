%
clear all;clc
datatype  = {'Modeling dataset'};

%  datatype = 'Modeling dataset' or 'literature dataset' or 'HPA dataset'

%
% 1¡¢download image
% This step only needs to be performed once to download the three dataset, if
% the dataset already exists in the corresponding folder, you can ignore this step.
% After this step is executed, the data in the ./part1/data/1_images/ folder needs
% to be copied to the ./part2/data/1_images/ folder.
addpath ./DATAProcess;
didwegt = DOWNLOADIMAGES2(datatype);
didwegt2 = EXTRACTPATCH(datatype);