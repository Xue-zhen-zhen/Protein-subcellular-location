function classifyPatterns(featPaths, statsData, classes, tissueLabels, writepath) 
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

% k-means clustering
% [X1,patchtotalfeatures]=k-means(patchpath);          
    
% 1. Load data
s_fp = zeros(length(featPaths),1); 
for i=1:length(featPaths)
    s_fp(i) = size(featPaths{i},2);
end
su_fp = sum(s_fp);
cs_fp = [0; cumsum( s_fp)]; cs_fp( end) = [];

data = zeros( su_fp, 592);
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
        features45=features.feats592_PNAS;
        features45(any(isnan(features45)'),:)=[];
        features=mean(features45);
        data(ind,:) = features;
        tlabels(ind) = tissueLabels{i}(j);
        clabels(ind) = i;
        stats(ind,:) = stat;
        images(ind) =  {[statsData{i}{j}(1:end-3) 'jpg']};
        idx_abID = find( statsData{i}{j}=='\');   
        alabels(ind) = str2num( statsData{i}{j}(idx_abID(2)+1:idx_abID(3)-1));
    end
end
%%%去除数据中的NAN

% clabels = images_Labels(images);
[m,n]=find(isnan(data));
ind=unique(m);
data(ind,:) = [];
stats(ind,:) = [];
clabels(ind) = [];
tlabels(ind) = [];
alabels(ind) = [];
images(ind) = [];

% 2. Remove bad images based on features/labels
% Remove cyan staining and images with too much black in them.
ind = find(stats(:,1)>13);
data(ind,:) = [];
stats(ind,:) = [];
clabels(ind) = [];
tlabels(ind) = [];
alabels(ind) = [];
images(ind) = [];


% 3. Remove bad features
%  data = data(:,[2:end]);
  data = data(:,[5:end]);

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

traindata = data(ttlist==1,:);   % X_train
testdata = data(ttlist==2,:);    % X_test

% 6. Feature selection by SDA
[traindata,testdata] = featnorm( traindata, testdata);
traindata = double( traindata*2-1);
testdata = double(testdata*2-1);

u = unique( trainlabels);
feat = []; feat{length(u)} = [];
for i=1:length(u)
    feat{i} = traindata( trainlabels==u(i), :);% 5:end);
end  
logfilename = [finalwritepath '_sdalog.txt'];      
idx_sda = ml_stepdisc( feat,logfilename);

% different features selected classfication
% [traindata , testdata] = featselected_lnfFS(traindata,trainlabels,testdata,testlabels);

% 7. Classification

% [mean_per_evalmodel,indices]=validation_10fold(ttlist,traindata,clabels,testdata,idx_sda);  %

[model,options] = trainClassifier( trainlabels,traindata(:,idx_sda));  

[predlabels,accuracy,weights] = svmpredict( testlabels,testdata(:,idx_sda), model,'-b 1');  

[C U D W] = conmatrix( testlabels, predlabels);

disp( 'conmatrix:');
disp(D);
disp( 'accuracy:');
disp(W);
disp(classes);
save( finalwritepath, 'model','options','idx_sda','predlabels','weights',...
    'trainlabels','testlabels','traindata','testdata','classes',...
    'trainlabels_tissue','testlabels_tissue',...
    'trainlabels_antibody','testlabels_antibody',...
    'trainimages','testimages','W','D');

% save(finalwritepath,'mean_per_evalmodel','idx_sda','traindata','testdata','clabels','classes','indices');

if doofus ==1
    fclose(fr);
    delete(pr);
end

return