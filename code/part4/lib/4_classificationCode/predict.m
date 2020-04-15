function predict(featPaths, statsData, classes, tissueLabels, writepath,feattype)

finalwritepath=writepath;    
finalwritepath((finalwritepath == ',')|(finalwritepath == '/')) = '&';

doofus = 1;
if doofus == 1
    if exist( finalwritepath,'file')
        return
    end
    prp = writepath;
    prp((prp == '\') | (prp == '.')|(prp ==':')|(prp == '/')|(prp == ',')|(prp=='&')) = '_';
    pr = ['tmp\classifying_' prp '.txt'];
    if ~exist( pr,'file')
        fr = fopen( pr, 'w');
    else
        return
    end
    if length(featPaths)~=length(classes)
        fclose(fr);
        delete(pr);
        error( 'check input values')
    end
end

% 1. Load data
s_fp = zeros(length(featPaths),1); 
for i=1:length(featPaths)
    s_fp(i) = size(featPaths{i},2);
end
su_fp = sum(s_fp);
cs_fp = [0; cumsum( s_fp)]; cs_fp( end) = [];

% data = zeros( su_fp, 592);
tlabels = zeros( su_fp, 1);
clabels = zeros( su_fp, 1);
alabels = zeros( su_fp,1);
stats = zeros( su_fp, 3);
images = []; images{su_fp} = [];
for i=1:length(featPaths)
    for j=1:s_fp(i)
        ind = cs_fp(i)+j;
        fid=fopen( statsData{i}{j},'r');  stat = fread(fid);  fclose(fid);
        stat(end)=[];  stat=char(stat)';  stat=str2num(stat);
        load( featPaths{i}{j});
        if strcmp(feattype,'SLFs')
            features45=features.feats592_PNAS;
            features45(any(isnan(features45)'),:)=[];
            features=mean(features45);
        else
            features848=features.feats848_PNAS;
            features848(any(isnan(features848)'),:)=[];
            features=mean(features848);
        end
        data(ind,:) = features;
        tlabels(ind) = tissueLabels{i}(j);
        clabels(ind) = i;
        stats(ind,:) = stat;
        images(ind) =  {[statsData{i}{j}(1:end-3) 'jpg']};
        idx_abID = find( statsData{i}{j}=='\');   
        alabels(ind) = str2num( statsData{i}{j}(idx_abID(3)+1:idx_abID(4)-1));
    end
end
index_1 = strfind(images{1},'\');
datatype = images{1}(index_1(1)+1:index_1(2)-1);
index_N = find(tlabels==1);  index_C = find(tlabels==2);
data_N = data(index_N,:);         data_C = data(index_C,:); 
tlabels_N = tlabels(index_N);     tlabels_C = tlabels(index_C);
clabels_N = clabels(index_N);     clabels_C = clabels(index_C);
stats_N = stats(index_N,:);       stats_C = stats(index_C,:);
images_N =  images(index_N);      images_C =  images(index_C);
alabels_N = alabels(index_N);     alabels_C = alabels(index_C);


didwegt = Classify(data_N,images_N,tlabels_N,clabels_N,stats_N,alabels_N,...
    datatype,'normal',finalwritepath);

didwegt2 = Classify(data_C,images_C,tlabels_C,clabels_C,stats_C,alabels_C,...
    datatype,'cancer',finalwritepath);
    

if doofus ==1
    fclose(fr);
    delete(pr);
end

return
