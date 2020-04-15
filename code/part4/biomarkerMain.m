% PROCESSDATA  a wrapper script that invokes unmixing,feature calculation,
% and clasification in two biomarker datasets. Two datasets need to be implemented twice. The model with the best results
% trained in the .\Part2\data\4_classification\ folder needs to be copied to the .\Part4\model folder.
% The data of the two datasets should be saved in the two folders./data/biomarkerI/ and ./data/biomarkerII/ ,respectively.
%
%
clear all; clc;
Twobiomarkerdataset = {'literaturedata'};
% Twobiomarkerdataset = 'literaturedata' or 'HPAdata'

id = 1;
task = {'parse','unmix','featcalc','classification'};
setup;
if strcmp(Twobiomarkerdataset,'literaturedata')
    % BiomarkerI
    load('.\matfile\literatureIDlabel(2).mat')
%     antibody_ids = {'3'};
%     classlabels ={'N'};
end
if strcmp(Twobiomarkerdataset,'HPAdata')
    % BiomarkerII
    % load('.\matfile\IDandLabels_HPA.mat');
    % classlabels = classlabels_n;
end

dbs = {'db4'};  %'db1', 'db2', 'db3', , 'db5', 'db6', 'db7', 'db8', 'db9', 'db10'};
umet = {'lin'};
featType = {'SLFs_LBPs'};
%
patchsize = {'75'};
patchnumber = {'205'};
%

% Always parse
for i=1:length(antibody_ids)
    options.general.ANTIBODY_IDS = antibody_ids(i);
    params = setOptions( options,antibody_ids,classlabels);
    data = prepareData( 'parse',params);
    handleData( data, params);
end

for m=1:length(featType)
    options.featCalc.FEATTYPE = featType{m};
    for k=1:length(umet)
        options.unmix.UMETHOD = umet{k};
        for j=1:length(dbs)
            options.featCalc.FEATSET = dbs{j};
            for s=1:length(patchsize)
                options.featCalc.patchsize = patchsize{s} ;
                for n=1:length(patchnumber)
                    options.featCalc.patchnumber = patchnumber{n};
                    switch task{id}
                        case 'unmix'
                            for i=1:length(antibody_ids)
                                options.general.ANTIBODY_IDS = antibody_ids(i);
                                options.general.CLASSLABELS = classlabels(i);
                                params = setOptions( options,antibody_ids,classlabels);
                                
                                data = prepareData( 'unmix',params);
                                handleData( data, params);
                            end
                        case 'featcalc'
                            for i=1:length(antibody_ids)
                                options.general.ANTIBODY_IDS = antibody_ids(i);
                                options.general.CLASSLABELS = classlabels(i);
                                params = setOptions( options,antibody_ids,classlabels);
                                
                                data = prepareData( 'unmix',params);
                                handleData( data, params);
                                
                                data = prepareData('calcFeat',params);
                                handleData( data, params);
                            end
                        case 'classification'
                            for i=1:length(antibody_ids)
                                options.general.ANTIBODY_IDS = antibody_ids(i);
                                options.general.CLASSLABELS = classlabels(i);
                                params = setOptions( options,antibody_ids,classlabels);
                                
                                data = prepareData( 'unmix',params);
                                handleData( data, params);
                                
                                data = prepareData( 'calcFeat',params);
                                handleData( data, params);
                            end
                            options.general.ANTIBODY_IDS = antibody_ids;
                            options.general.CLASSLABELS = classlabels;
                            params = setOptions( options,antibody_ids,classlabels);
                            if strcmp(Twobiomarkerdataset,'literaturedata')
                                data = prepareData( 'classify',params);
                            elseif strcmp(Twobiomarkerdataset,'HPAdata')
                                data = prepareDataII( 'classify',params);
                            end
                            handleData(data, params);
                    end
                end
            end
        end
    end
end

if strcmp(Twobiomarkerdataset,'literaturedata')
    load('./matfile/liter(2).mat')
    InfoProtein = ProteinSIQL;
    [h,p_value] = Ttest(InfoProtein,'literaturedata');
    save('./literesult.mat','h','p_value')
elseif strcmp(Twobiomarkerdataset,'HPAdata')
    load('./matfile/finallyProteinInfo.mat');
    [h,p_value] = Ttest(InfoProtein,'HPAdata');
    save('./HPAresult.mat','h','p_value')
end
   
    
    
