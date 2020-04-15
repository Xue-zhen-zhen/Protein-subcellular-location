% PROCESSDATA  a wrapper script that invokes
%   step 1¡¢unmixing,feature calculation, and clasification in case of extract patch from whole image
%   step 2¡¢combined SLFs_LBP features under the patch selects the optimal parameters and
%      pre-trained network features
%   step 3¡¢obtaind the model that combined SLFs_LBP features under the patch selects the optimal parameters and
%     seven pre-trained network features

clear all;clc;
runcondation = {'OnlyExtractPatchfeat'};
% runcondation = 'OnlyExtractPatchfeat' or 'CombinedSLFs_LBPandDeepfeat'

id =4;
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
% antibody_ids = {'00031'};
% classlabels = {'CM'};


dbs = {'db4'};  %'db1','db2', 'db3',,'db5', 'db6', 'db7', 'db8', 'db9', 'db10'
umet = {'lin'};
featType = {'SLFs','SLFs_LBPs'}; 
splitMethod = {'per image','per protein'};

if strcmp(runcondation ,'OnlyExtractPatchfeat')
    patchsize = {'45','75','105','135','165','195','225'}; 
    patchnumber = {'5','25','45','65','85','105','125','145','165','185','205',...
       '225','245','265','285','305','325','345','365','385'};
elseif strcmp(runcondation ,'CombinedSLFs_LBPandDeepfeat')
    patchsize = {'75'};
    patchnumber = {'205'};
end

% Always parse
for i=1:length(antibody_ids)
    options.general.ANTIBODY_IDS = antibody_ids(i);
    params = setOptions( options,antibody_ids,classlabels);
    data = prepareData( 'parse',params);
    handleData( data, params);
end
for r=1:length(runcondation)
    options.classify.RunCondation = runcondation{r};
    for g=1:length(splitMethod)
        options.classify.SPLITMETHOD = splitMethod{g};
        for m=1:length(featType)
            options.featCalc.FEATTYPE = featType{m};
            for k=1:length(umet)
                options.unmix.UMETHOD = umet{k};
                for j=1:length(dbs)
                    options.featCalc.FEATSET = dbs{j};
                    for s=1:length(patchsize)   %%%
                        options.featCalc.patchsize = patchsize{s} ;
                        for n=1:length(patchnumber)
                            options.featCalc.patchnumber = patchnumber{n};  %%%
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
        end
    end
end
