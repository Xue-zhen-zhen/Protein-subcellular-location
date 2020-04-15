function classifyPatterns(featPaths, statsData, classes, tissueLabels, writepath,feattype,splittype,RUNcondation)
% CLASSIFYPATTERNS( FEATPATHS, STATSDATA, CLASSES, TISSUELABELS, WRITEPATH, METHOD)
%   Classification wrapper function.

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
        alabels(ind) = str2num( statsData{i}{j}(idx_abID(2)+1:idx_abID(3)-1));
    end
end

% perprotein split
if strcmp( splittype, 'per protein')
    indices = per_protein(alabels);
end

% combined SLFs_LBP features under the patch selects the optimal parameters and pre-trained network features
%
if strcmp(RUNcondation,'CombinedSLFs_LBPandDeepfeat')
    data1 = features_1000_merge(data,images,clabels,splittype,'resent18');
    data2 = features_1000_merge(data,images,clabels,splittype,'resent50');
    data3 = features_1000_merge(data,images,clabels,splittype,'densenet201');
    data4 = features_1000_merge(data,images,clabels,splittype,'GapNet-PL');
    data5 = features_1000_merge(data,images,clabels,splittype,'googlenet');
    data6 = features_1000_merge(data,images,clabels,splittype,'inceptionv3');
    data7 = features_1000_merge(data,images,clabels,splittype,'resnet101');
    data = [data1 data2 data3 data4 data5 data6 data7];
end

% delete NAN
[m,n]=find(isnan(data));
ind=unique(m);
data(ind,:) = [];
stats(ind,:) = [];
clabels(ind) = [];
tlabels(ind) = [];
alabels(ind) = [];
images(ind) = [];
if strcmp( splittype, 'per protein')
    indices(ind) = [];  %perprotein
end

% 2. Remove bad images based on features/labels
% Remove cyan staining and images with too much black in them.
ind = find(stats(:,1)>13);
data(ind,:) = [];
stats(ind,:) = [];
clabels(ind) = [];
tlabels(ind) = [];
alabels(ind) = [];
images(ind) = [];
if strcmp( splittype, 'per protein')
    indices(ind) = [];  %perprotein
end

% 3. Remove bad features
%  data = data(:,[2:end]);
if strcmp(RUNcondation,'CombinedSLFs_LBPandDeepfeat')
    data1 = data1(:,[5:end]);  data6 = data6(:,[5:end]);
    data2 = data2(:,[5:end]);  data7 = data7(:,[5:end]);
    data3= data3(:,[5:end]);   data5 = data5(:,[5:end]);
    data4 = data4(:,[5:end]);
    data = [data1 data2 data3 data4 data5 data6 data7];
elseif strcmp(RUNcondation,'OnlyExtractPatchfeat')
    data = data(:,[5:end]);
end


% 4. Remove cases where there is only one tissue/location combination
sampleID = str2num([num2str(clabels) num2str(tlabels)]);
[c b] = hist( sampleID, [1:1:max(sampleID)]);
idx = find(c==1);

ind = zeros(size(idx));
for i=1:length(idx)
    ind(i) = find(sampleID==idx(i));
end

data(ind,:) = [];
stats(ind,:) = [];
clabels(ind) = [];
tlabels(ind) = [];
alabels(ind) = [];
images(ind) = [];
if strcmp( splittype, 'per protein')
    indices(ind) = [];  %perprotein
end

% 5. Data partitioning
% Done in the even tissues/class then even antibodies/class approach
u_c = unique( clabels);
[u_Abs I J] = unique(alabels);
bool = 0;
ttlist = zeros( size( clabels));
for i=1:length(u_c)
    idx = find( clabels==u_c(i));
    s_tlabels = tlabels(idx);
    s_alabels = J(idx);
    
    [c_t u_t] = hist( s_tlabels, 1:1:65);
    u_t = u_t(c_t>0);
    
    for j=1:length(u_t)
        idx2 = find(s_tlabels==u_t(j));
        s2_alabels = s_alabels(idx2);
        [c_a u_a] = hist( s2_alabels, 1:1:max(u_Abs));
        u_a = u_a(c_a>0);
        
        for k=1:length(u_a)
            idx3 = find(s2_alabels==u_a(k));
            my_idx = mod(bool:bool+length(idx3)-1,2)+1;
            if mod( length(idx3), 2)
                bool = mod(bool + 1,2);
            end
            ttlist(idx(idx2(idx3))) = my_idx;
        end
    end
end

trainlabels = clabels(ttlist==1);  % Y_train
testlabels = clabels(ttlist==2);   % Y_test
trainlabels_tissue = tlabels(ttlist==1);
testlabels_tissue = tlabels(ttlist==2);
trainlabels_antibody = alabels(ttlist==1);
testlabels_antibody = alabels(ttlist==2);
trainimages = images(ttlist==1);
testimages = images(ttlist==2);

if strcmp(RUNcondation,'OnlyExtractPatchfeat')
    traindata = data(ttlist==1,:);   % X_train
    testdata = data(ttlist==2,:);    % X_test
    Traindata = traindata;
    % 6. Feature selection by SDA
    [traindata,testdata] = featnorm( traindata, testdata);
    traindata = double( traindata*2-1);
    testdata = double(testdata*2-1);
    
    u = unique( trainlabels);
    feat = []; feat{length(u)} = [];
    for i=1:length(u)
        feat{i} = traindata( trainlabels==u(i), :); % 5:end);
    end
    logfilename = [finalwritepath '_sdalog.txt'];
    idx_sda = ml_stepdisc( feat,logfilename);
elseif strcmp(RUNcondation,'CombinedSLFs_LBPandDeepfeat')
    [traindata1,testdata1,idx_sda1,Traindata1] = SDA(data1,ttlist,trainlabels,finalwritepath,'resent18',clabels);
    [traindata2,testdata2,idx_sda2,Traindata2] = SDA(data2,ttlist,trainlabels,finalwritepath,'resent50',clabels);
    [traindata3,testdata3,idx_sda3,Traindata3] = SDA(data3,ttlist,trainlabels,finalwritepath,'densenet201',clabels);
    [traindata4,testdata4,idx_sda4,Traindata4] = SDA(data4,ttlist,trainlabels,finalwritepath,'GapNet-PL',clabels);
    [traindata5,testdata5,idx_sda5,Traindata5] = SDA(data5,ttlist,trainlabels,finalwritepath,'googlenet',clabels);
    [traindata6,testdata6,idx_sda6,Traindata6] = SDA(data6,ttlist,trainlabels,finalwritepath,'inceptionv3',clabels);
    [traindata7,testdata7,idx_sda7,Traindata7] = SDA(data7,ttlist,trainlabels,finalwritepath,'resnet101',clabels);
    [traindata8,testdata8,idx_sda8,Traindata8] = SDA(data,ttlist,trainlabels,finalwritepath,'ensemblenetwork',clabels);
end

% Train the Model
% [model,options] = trainModel(ttlist,traindata,clabels,testdata,idx_sda);
% save(finalwritepath,'model','options','Traindata','idx_sda');


% 7. Classification
if strcmp(RUNcondation,'OnlyExtractPatchfeat')
    if strcmp( splittype, 'per protein')
        [mean_per_evalmodel,indices]=validation_10fold(ttlist,traindata,clabels,testdata,idx_sda,indices);  %
    end
    if strcmp( splittype, 'per image')
        [mean_per_evalmodel,indices]=validation_10fold_perimage(ttlist,traindata,clabels,testdata,idx_sda);  %
    end
    disp(classes);
    save(finalwritepath,'mean_per_evalmodel','idx_sda','traindata','testdata','clabels','classes','indices');
    
elseif strcmp(RUNcondation,'CombinedSLFs_LBPandDeepfeat')
    if strcmp( splittype, 'per protein')
        [mean_per_evalmodel_1,indices_1]=validation_10fold(ttlist,traindata1,clabels,testdata1,idx_sda1,indices);
        [mean_per_evalmodel_2,indices_2]=validation_10fold(ttlist,traindata2,clabels,testdata2,idx_sda2,indices);
        [mean_per_evalmodel_3,indices_3]=validation_10fold(ttlist,traindata3,clabels,testdata3,idx_sda3,indices);
        [mean_per_evalmodel_4,indices_4]=validation_10fold(ttlist,traindata4,clabels,testdata4,idx_sda4,indices);
        [mean_per_evalmodel_5,indices_5]=validation_10fold(ttlist,traindata5,clabels,testdata5,idx_sda5,indices);
        [mean_per_evalmodel_6,indices_6]=validation_10fold(ttlist,traindata6,clabels,testdata6,idx_sda6,indices);
        [mean_per_evalmodel_7,indices_7]=validation_10fold(ttlist,traindata7,clabels,testdata7,idx_sda7,indices);
        [mean_per_evalmodel,indices]=validation_10fold(ttlist,traindata8,clabels,testdata8,idx_sda8,indices);
    end
    if strcmp( splittype, 'per image')
        [mean_per_evalmodel_1,indices_1]=validation_10fold_perimage(ttlist,traindata1,clabels,testdata1,idx_sda1);
        [mean_per_evalmodel_2,indices_2]=validation_10fold_perimage(ttlist,traindata2,clabels,testdata2,idx_sda2);
        [mean_per_evalmodel_3,indices_3]=validation_10fold_perimage(ttlist,traindata3,clabels,testdata3,idx_sda3);
        [mean_per_evalmodel_4,indices_4]=validation_10fold_perimage(ttlist,traindata4,clabels,testdata4,idx_sda4);
        [mean_per_evalmodel_5,indices_5]=validation_10fold_perimage(ttlist,traindata5,clabels,testdata5,idx_sda5);
        [mean_per_evalmodel_6,indices_6]=validation_10fold_perimage(ttlist,traindata6,clabels,testdata6,idx_sda6);
        [mean_per_evalmodel_7,indices_7]=validation_10fold_perimage(ttlist,traindata7,clabels,testdata7,idx_sda7);
        [mean_per_evalmodel,indices]=validation_10fold_perimage(ttlist,traindata8,clabels,testdata8,idx_sda8);
    end
    save([finalwritepath(1:end-4) '_1.mat'],'mean_per_evalmodel_1','idx_sda1','traindata1','testdata1','clabels','classes','indices_1')
    save([finalwritepath(1:end-4) '_2.mat'],'mean_per_evalmodel_2','idx_sda2','traindata2','testdata2','clabels','classes','indices_2')
    save([finalwritepath(1:end-4) '_3.mat'],'mean_per_evalmodel_3','idx_sda3','traindata3','testdata3','clabels','classes','indices_3')
    save([finalwritepath(1:end-4) '_4.mat'],'mean_per_evalmodel_4','idx_sda4','traindata4','testdata4','clabels','classes','indices_4')
    save([finalwritepath(1:end-4) '_5.mat'],'mean_per_evalmodel_5','idx_sda5','traindata5','testdata5','clabels','classes','indices_5')
    save([finalwritepath(1:end-4) '_6.mat'],'mean_per_evalmodel_6','idx_sda6','traindata6','testdata6','clabels','classes','indices_6')
    save([finalwritepath(1:end-4) '_7.mat'],'mean_per_evalmodel_7','idx_sda7','traindata7','testdata7','clabels','classes','indices_7')
    save([finalwritepath(1:end-4) '_8.mat'],'mean_per_evalmodel','idx_sda8','traindata8','testdata8','clabels','classes','indices')
end
if doofus ==1
    fclose(fr);
    delete(pr);
end

return

