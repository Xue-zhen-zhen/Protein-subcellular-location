function handleData( data, params)
% PROCESSDATA( PROCPARMS, SIMUPARMS)

if ~exist( 'data','var')
    error( 'Please input processing parameters');
end
if ~exist( 'params','var')
    error( 'Please input simulation parameters');
end
dbtype = params.featCalc.FEATSET;
NLEVELS = params.featCalc.NLEVELS;
method = data.method;
feattype=params.featCalc.FEATTYPE;
datasplitMethod = params.classify.SPLITMETHOD;
%

%
[success wrnmsg wrnmsgID] = mkdir(data.writedir,data.str);  

for i=1:length(data.writeData)

    [success wrnmsg wrnmsgID] = mkdir(data.writedir1{i}, data.writedirChild1{i});
    [success wrnmsg wrnmsgID] = mkdir(data.writedir2{i}, data.writedirChild2{i});
    [success wrnmsg wrnmsgID] = mkdir(data.writedir3{i}, data.writedirChild3{i});
       

    switch method
        case 'unmix'
            processImage( data.pathData{i}, data.writeData{i},data.WData{i},  params.unmix);   %%
        case 'calcFeat'
            calcufeat(data.imgpathData{i}, data.writeData{i}, data.WData{i}, dbtype, NLEVELS,feattype); %,patchsize,patchnumber
        case 'classify'
            classifyPatterns( data.pathData, data.statsData, data.classes, data.tissueLabels, data.writeData{i},datasplitMethod); % data.Datapatch
        case 'parse'
            imageStats(data.pathData{i}, data.writeData{i}); 
        otherwise
            error( 'not supported yet');
    end
end
