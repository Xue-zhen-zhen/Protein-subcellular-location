% PROCESSDATA  a wrapper script that invokes unmixing,
%   feature calculation, and clasification in the case of the whole image


clear all;clc;
id =1;
task = {'parse','unmix','featcalc','classification'};
setup;
load('.\IDandLabels_MD.mat')
firclasslabels = classlabels;
clear classlabels
% [antibody_ids,firclasslabels] = getDataInfo();
classlabels=cell(1,length(firclasslabels));
for i=1:length(firclasslabels)
    mclasslabels=firclasslabels{i};
    mclasslabels(mclasslabels==',')='&';
    classlabels{i}=mclasslabels;
end

dbs = { 'db1','db2', 'db3','db4', 'db5', 'db6','db7', 'db8', 'db9', 'db10'};
umet = {'lin','nmf'};
featType = {'SLFs','SLFs_LBPs'}; 
splitMethod = {'per image','per protein'}; 

% Always parse
for i=1:length(antibody_ids)
    options.general.ANTIBODY_IDS = antibody_ids(i);
    params = setOptions( options,antibody_ids,classlabels);
    data = prepareData( 'parse',params);
    handleData( data, params);
end
for g=1:length(splitMethod)
    options.classify.SPLITMETHOD = splitMethod{g};
    for m=1:length(featType)
        options.featCalc.FEATTYPE = featType{m};
        for k=1:length(umet)
            options.unmix.UMETHOD = umet{k};
            for j=1:length(dbs)
                options.featCalc.FEATSET = dbs{j};
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
                        
                        data = prepareData( 'classify',params);
                        handleData(data, params);
                    otherwise
                end
            end
        end
    end
end
