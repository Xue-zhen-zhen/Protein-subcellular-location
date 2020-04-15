function didwegt = Classify(data_N,images_N,tlabels,clabels,stats,alabels,datatype,condation,finalwritepath)
if strcmp(condation,'normal')
    PredLabelN = [];
    WeightN = [];
    antibodyIDN = []; imN = []; labelsN =[];
elseif strcmp(condation,'cancer')
    PredLabelC = [];
    WeightC = [];
    antibodyIDC = []; imC = []; labelsC =[];
end

NetworkType = {'resent18','resent50','densenet201','GapNet-PL','googlenet','inceptionv3','resnet101'};
for i=1:length(NetworkType)
    
    [data,clabels_out] = features_1000_merge(data_N,images_N,condation,datatype,NetworkType{i});
    
    a1= clabels_out;
    if ~isequal(clabels,clabels_out)
        clabels = a1;
    end
    
    % clabels = images_Labels(images);
    [m,n]=find(isnan(data));
    ind=unique(m);
    data(ind,:) = [];
    stats(ind,:) = [];
    clabels(ind) = [];
    tlabels(ind) = [];
    alabels(ind) = [];
    images_N(ind) = [];
    
    %
    features = data(:,[5:end]);
    
    % load trained model
    % load('.\model\SLFs\SLFsdensenet201.mat','model','Traindata','idx_sda');
    load(['.\part4\model\per protein\SLFs_LBPs\lin_db4_75_205\' NetworkType{i} '.mat'],'model','Traindata','idx_sda');
    
    [traindata,Features] = featnorm( Traindata, features);
    features = double(Features*2-1);
    [predlabels,accuracy,weights] = svmpredict(clabels,features(:,idx_sda),model,'-b 1');
    
    % [W_n,W_c] = getWeigths(alabels,images,weights,clabels,predlabels);
    
    testTarget = zeros(2,length(clabels));
    preTable = zeros(2,length(clabels));
    ind0=find(clabels==1); ind1=find(clabels==2); ind2=find(clabels==3);
    testTarget(1,ind0) = 1;     testTarget(:,ind1)= 1;     testTarget(2,ind2) = 1;
    index0 = predlabels==1; index1 = find(predlabels==2); index2 = find(predlabels==3);
    preTable(1,index0)= 1;         preTable(:,index1)=1;         preTable(2,index2)= 1;
    subset_accuracy = S_accuracy(preTable,testTarget);
    [accuracy_test,recall,precision,F1_score] = Accuracy(preTable,testTarget);
    [label_accuracy, average_label_accuracy] = L_accuracy(preTable,testTarget);
    
    % save('.\weights_cancer.mat','weights','images','alabels','clabels','predlabels');
    
    save([finalwritepath(1:end-4) '_' condation '_' NetworkType{i} '.mat'],'predlabels','accuracy','weights',...
        'idx_sda','features','alabels','images_N','clabels','accuracy_test');
    
    if strcmp(condation,'normal')
        PredLabelN = [PredLabelN;predlabels]; WeightN = [WeightN;weights];
        antibodyIDN = [antibodyIDN;alabels]; imN = [imN;images']; labelsN = [labelsN;clabels];
    elseif strcmp(condation,'cancer')
        PredLabelC = [PredLabelC;predlabels]; WeightC = [WeightC;weights];
        antibodyIDC = [antibodyIDC;alabels]; imC = [imC;images']; labelsC = [labelsC;clabels];
    end
end
if strcmp(condation,'normal')
    save([finalwritepath(1:end-4) '_' condation '_ALL.mat'],'PredLabelN','WeightN','antibodyIDN','imN','labelsN')
elseif strcmp(condation,'cancer')
    save([finalwritepath(1:end-4) '_' condation '_ALL.mat'],'PredLabelC','WeightC','antibodyIDC','imC','labelsC')
end
didwegt = 1;
