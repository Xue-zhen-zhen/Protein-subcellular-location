function outputs = prepareData( method, params)
% OUTPUTS = PREPAREDATA( METHOD, PARAMS)

if ~exist( 'method','var')
    errmsg = ['Please specify method: ''unmix'', ''calcFeat'', ''classify'', or ''getResults''.'];
    error(errmsg);
end

if ~exist( 'params','var')
    error( 'Please input simulation parameters');
end

% params = setOptions( params);

outputs.method = method;
umethod = params.unmix.UMETHOD;
featset = params.featCalc.FEATSET;
feattype = params.featCalc.FEATTYPE;
datasplitMethod = params.classify.SPLITMETHOD; 
RUNcondation = params.classify.RunCondation; 

%
patchsize = params.featCalc.patchsize;
patchnumber = params.featCalc.patchnumber;
%

switch method
    case 'parse'
        classes = params.general.ANTIBODY_IDS;
        datadir = params.general.DATAROOT;
        writedir = [params.general.WRITEROOT '\1_images\'];
        readtail = 'jpg';
        writetail = 'txt';
        addFolder1 = '';
        addFolder2 = '';
    case 'unmix'
        classes = params.general.ANTIBODY_IDS;
        datadir = params.general.DATAROOT;
        writedir = [params.general.WRITEROOT '\2_unmixedImages\'];
        readtail = 'jpg';
        writetail = 'png';
        Wtail='mat';
        addFolder1 = '';
        addFolder2 = umethod;
    case 'calcFeat'
        classes = params.general.ANTIBODY_IDS;
        datadir = [params.general.WRITEROOT '\2_unmixedImages\'];
        imgdatadir = [params.general.WRITEROOT '\1_images\'];
        writedir = [params.general.WRITEROOT '\3_features\'];
        readtail = 'png';
        imgreadtail = 'jpg';
        writetail = 'mat';
        Wtail='mat';
        imgaddFolder = '';
        addFolder1 = umethod;  
        addFolder2 = [feattype '\' umethod '_' featset '_' patchsize '_' patchnumber];  %%%
    case 'classify'
        classes = params.general.CLASSLABELS;
        datadir = [params.general.WRITEROOT '\3_features\'];
        writedir = [params.general.WRITEROOT '\4_classification\'];
        readtail = 'mat';
        writetail = 'mat';
        addFolder1 = [feattype '\' umethod '_' featset '_' patchsize '_' patchnumber]; %%%
        addFolder2 = [RUNcondation '\' datasplitMethod '\' feattype '\' umethod '_' featset '_' patchsize '_' patchnumber];  
    otherwise
        error( 'Please enter a valid method');
end

outputs.writedir = writedir;
outputs.str = addFolder2;

switch params.general.CONDITION
    case 'all'
        conditions = {'normal','cancer'};
    case 'normal'
        conditions = {'normal'};
    case 'cancer'
        conditions = {'cancer'};
    otherwise
end

antibodies = params.general.ANTIBODY_IDS;
tissues = params.general.TISSUES;

datadir = [datadir '\' addFolder1 '\'];
writedir = [writedir '\' addFolder2 '\'];


if (strcmp( method, 'parse') || strcmp( method, 'unmix') )   %  || strcmp( method, 'calcFeat'))
    counter = 0;
    for i1=1:length(antibodies)
        pathAntiID = [datadir '\' antibodies{i1}];
        writeAntiID = [writedir '\' antibodies{i1}];

        for i2=1:length(conditions)
            pathCondition = [pathAntiID '\' conditions{i2}];
            writeCondition = [writeAntiID '\' conditions{i2}];

            for i3=1:length(tissues)
                pathTissue = [pathCondition '\' tissues{i3}];
                dirData = dir([pathTissue '\*' readtail]);
                writeTissue = [writeCondition '\' tissues{i3}];

                for i4=1:length(dirData)
                    counter = counter+1;
                    outputs.pathData{counter} = [pathTissue '\' dirData(i4).name];
                    outputs.writeData{counter} = [writeTissue '\' dirData(i4).name(1:end-3) writetail];
                    if (strcmp( method, 'unmix'))
                        outputs.WData{counter} = [writeTissue '\' dirData(i4).name(1:end-3) Wtail];
                    end
                    outputs.writedir1{counter} = writedir;
                    outputs.writedirChild1{counter} = antibodies{i1};
                    outputs.writedir2{counter} = writeAntiID;
                    outputs.writedirChild2{counter} = conditions{i2};
                    outputs.writedir3{counter} = writeCondition;
                    outputs.writedirChild3{counter} = tissues{i3};
                end
            end
        end
    end
end


if(strcmp( method, 'calcFeat'))
    imgdatadir = [imgdatadir '\' imgaddFolder '\'];
    counter = 0;
    for i1=1:length(antibodies)
        pathAntiID = [datadir '\' antibodies{i1}];
        writeAntiID = [writedir '\' antibodies{i1}];
        imgAntiID = [imgdatadir '\' antibodies{i1}];
        
        for i2=1:length(conditions)
            pathCondition = [pathAntiID '\' conditions{i2}];
            writeCondition = [writeAntiID '\' conditions{i2}];
            imgCondition = [imgAntiID '\' conditions{i2}];

            for i3=1:length(tissues)
                pathTissue = [pathCondition '\' tissues{i3}];
                imgpathTissue = [imgCondition '\' tissues{i3}];
                dirData = dir([pathTissue '\*' readtail]);
                imgdirData = dir([imgpathTissue '\*' imgreadtail]);
                writeTissue = [writeCondition '\' tissues{i3}];

                for i4=1:length(dirData)
                    counter = counter+1;
                    outputs.pathData{counter} = [pathTissue '\' dirData(i4).name];
                    outputs.imgpathData{counter} = [imgpathTissue '\' imgdirData(i4).name];
                    outputs.writeData{counter} = [writeTissue '\' dirData(i4).name(1:end-3) writetail];
                    outputs.WData{counter} = [pathTissue '\' dirData(i4).name(1:end-3) Wtail];
                    
                    outputs.writedir1{counter} = writedir;
                    outputs.writedirChild1{counter} = antibodies{i1};
                    outputs.writedir2{counter} = writeAntiID;
                    outputs.writedirChild2{counter} = conditions{i2};
                    outputs.writedir3{counter} = writeCondition;
                    outputs.writedirChild3{counter} = tissues{i3};
                    
                end
            end
        end
    end
end
        
    
% Classification uses different structure since classifiers are trained on multiple classes
if (strcmp( method, 'classify'))
 for i1=1:length(classes)

        counter = 0;

        pathAntiID = [datadir '\' antibodies{i1}];
        writeAntiID = [writedir '\' antibodies{i1}];

        for i2=1:length(conditions)
            pathCondition = [pathAntiID '\' conditions{i2}];
            writeCondition = [writeAntiID '\' conditions{i2}];

            for i3=1:length(tissues)
                pathTissue = [pathCondition '\' tissues{i3}];
                dirData = dir([pathTissue '\*' readtail]);
                writeTissue = [writeCondition '\' tissues{i3}];

                for i4=1:length(dirData)
                    counter = counter+1;
                    outputs.pathData{i1}{counter} = [pathTissue '\' dirData(i4).name];
                    outputs.statsData{i1}{counter} = ['data\1_images\' antibodies{i1} '\' conditions{i2} '\' tissues{i3} '\' dirData(i4).name(1:end-3) 'txt'];
                    outputs.antiID{i1}{counter} = antibodies{i1};
                    outputs.tissueLabels{i1}(counter) = i3;
                end
            end
        end
end

    [U I J] = unique(classes);
    temp = [];
    temp.writedir = outputs.writedir;
    temp.method = method;
    temp.str = outputs.str;
    str = [];
    for i=1:max(J)
        ind = find(J==i);
        temp.pathData{i} = [];
        temp.statsData{i} =[];
        temp.tissueLabels{i} = [];
        temp.antiID{i} = [];
        for j=1:length(ind)
            temp.pathData{i} = [temp.pathData{i} outputs.pathData{ind(j)}];
            temp.statsData{i} = [temp.statsData{i} outputs.statsData{ind(j)}];
            temp.tissueLabels{i} = [temp.tissueLabels{i} outputs.tissueLabels{ind(j)}];
            temp.antiID{i} = [temp.antiID{i} outputs.antiID{ind(j)}];
        end
        str = [str U{i} '_'];
    end
    str(end) = [];
    Datapatch=outputs.pathData;       %增加
    outputs = temp;
    outputs.Datapatch=Datapatch;      %增加
    outputs.classes = U;

    outputs.writeData{1} = [writedir '\' str '.mat'];
    outputs.writedir1{1} = [];
    outputs.writedirChild1{1} = [];
    outputs.writedir2{1} = [];
    outputs.writedirChild2{1} = [];
    outputs.writedir3{1} = [];
    outputs.writedirChild3{1} = [];
end

% Getting result can use single or multiple classifiers, FIX THIS SECTION
if (strcmp( method, 'getResults'))
    d = dir([datadir '/*.mat']);
    if length(d)
        outputs.writeData{1} = [writedir '/' d(1).name(1:end-3)];
    else
        error( 'Need to train and test a classifier');
    end
    outputs.pathData{1} = [datadir '/' d(1).name];
    outputs.writedir1{1} = [];
    outputs.writedirChild1{1} = [];
    outputs.writedir2{1} = [];
    outputs.writedirChild2{1} = [];
    outputs.writedir3{1} = [];
    outputs.writedirChild3{1} = [];
end

return



