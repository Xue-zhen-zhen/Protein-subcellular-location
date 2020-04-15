function options = setOptions(inputs,antibody_ids,classlabels)

if ~exist( 'inputs','var')
	inputs = [];
end

% 0. Set inputs 
inputs = setInputs( inputs);

% 1. Setting general parameters 
options.general = setGeneral( inputs.general,antibody_ids,classlabels);  %add antibody_ids,classlabels

% 2. Setting unmixing parameters
options.unmix = setUnmix(inputs.unmix);

% 3. Setting feature calculation parameters
options.featCalc = setFeatCalc( inputs.featCalc);

% 4. Classification parameters
inputs.classify.FEATSET = options.featCalc.FEATSET;   %remove
options.classify = setClassify( inputs.classify);

return


function options = setInputs(inputs)
options.general = [];
options.unmix = [];
options.featCalc = [];
options.classify = [];
options.getResults = [];

checker.options = fieldnames(options);
if exist('inputs','var')   
    try
        checker.inputs = fieldnames(inputs);
        for i=1:length(checker.inputs)
            checker.type = checker.inputs{i};
            checker.value = getfield( inputs,checker.inputs{i});
            options = setfield( options, checker.type, checker.value);
        end
    catch

    end
end

return


function options = setGeneral(inputs,antibody_ids,classlabels)  %add antibody_ids,classlabels

options.ANTIBODY_IDS = antibody_ids;
options.CONDITION = 'all';  
options.CLASSLABELS = classlabels;

options.DATAROOT = '.\data\biomarkerI\1_images\'; % \data\biomarkerII\1_images\
options.WRITEROOT = '.\data\biomarkerI\'; % \data\biomarkerII\
options.TISSUES = {'colon','colorectal cancer'}; % 


checker.options = fieldnames(options);
if exist('inputs','var')
    try
        checker.inputs = fieldnames(inputs);
        for i=1:length(checker.inputs)
            checker.type = checker.inputs{i};
            checker.value = getfield(inputs,checker.inputs{i});
            options = setfield( options, checker.type, checker.value);  
        end
    catch

    end
end

return


function options = setUnmix( inputs)
% For definitions of the parameters, please see decompTissue.m in the lib/2_unmix folder
options.UMETHOD = 'lin';
options.ITER = 5000;
options.INIT = 'truncated';
options.RSEED = 13;
options.RANK = 2;
options.STOPCONN = 40;
options.VERBOSE = 1;  

bf = '.\lib\2_unmixingCode\Wbasis.mat';   
load( bf);
options.W = W;

checker.options = fieldnames(options);
if exist('inputs','var')
    try
        checker.inputs = fieldnames(inputs);
        for i=1:length(checker.inputs)
            checker.type = checker.inputs{i};
            checker.value = getfield( inputs,checker.inputs{i});
            options = setfield( options, checker.type, checker.value);
        end
    catch

    end
end

return


function options = setFeatCalc( inputs)
options.FEATSET = 'db4';
options.NLEVELS = 10;
options.FEATTYPE = 'SLFs';
% options.SPLITMETHOD='per image';
%
options.patchsize = '75';
options.patchnumber = '205';
%

checker.options = fieldnames(options);
if exist('inputs','var')
    try
        checker.inputs = fieldnames(inputs);
        for i=1:length(checker.inputs)
            checker.type = checker.inputs{i};
            checker.value = getfield( inputs,checker.inputs{i});
            options = setfield( options, checker.type, checker.value);
        end
    catch

    end
end

return


function options = setClassify( inputs)
options.FEATSET = 'db4';
options.CMETHOD = 'simple';  
options.CAPPROACH = 'protein'; %or by tissue, or other groups, protein only for now
% options.SPLITMETHOD='per image';

checker.options = fieldnames(options);
if exist('inputs','var')
    try
        checker.inputs = fieldnames(inputs);
        for i=1:length(checker.inputs)
            checker.type = checker.inputs{i};
            checker.value = getfield( inputs,checker.inputs{i});
            options = setfield( options, checker.type, checker.value);
        end
    catch

    end
end

return


function options = setResults( inputs)
options.FEATSET = 'db4';
options.CMETHOD = 'simple';  
options.CAPPROACH = 'protein';

checker.options = fieldnames(options);
if exist('inputs','var')
    try
        checker.inputs = fieldnames(inputs);
        for i=1:length(checker.inputs)
            checker.type = checker.inputs{i};
            checker.value = getfield( inputs,checker.inputs{i});
            options = setfield( options, checker.type, checker.value);
        end
    catch

    end
end

return

