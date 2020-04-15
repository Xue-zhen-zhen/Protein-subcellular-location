load('dataID2.mat','antibody_ids');
load('data2.mat');
load('.\patchttest\biomarker2result\biomarker_normal.mat'); YLabel_normal = YLabel;
load('.\patchttest\biomarker2result\biomarker_cancer.mat'); YLabel_cancer = YLabel;
load('ID2images_cancer.mat');
load('ID2images_normal.mat');
for k=1:length(patch_cancer)
    idex0 = strfind(patch_cancer{k},'\');
    idex1 = strfind(patch_cancer{k},'(');
    dataC(k,1) = cellstr([patch_cancer{k}(idex0(end)+1:idex1-2) '.jpg']);
end
for g=1:length(patch_normal)
    indn0 = strfind(patch_normal{g},'\');
    indn1 = strfind(patch_normal{g},'(');
    dataN(g,1) = cellstr([patch_normal{g}(indn0(end)+1:indn1-2) '.jpg']);
end
for i=1:length(antibody_ids)
    indC = find(strcmp(ID_c,antibody_ids{i}));
    indN = find(strcmp(ID_n,antibody_ids{i}));
    image_c = images_cancer(indC); image_n = images_normal(indN);
    for c=1:length(image_c)
        Num = find(strcmp(dataC,image_c{c}));
        weightC((c-1)*35+1:c*35,:) = probs_cancer(Num,:); 
        pred_LabelC((c-1)*35+1:c*35,:) = YPred_cancer(Num,:);
        true_LabelC((c-1)*35+1:c*35,:) = YLabel_cancer(Num,:);
    end
%     [pred2model_LabelC] = model2Label(image_c,dataC,'cancer');
%     pred_LabelC(35*length(image_c)+1:2*35*length(image_c)) = pred2model_LabelC;
    TrueLabelC = unique(true_LabelC);
    [label_pC ia1 ic1] = unique(pred_LabelC);
    count = hist(pred_LabelC,label_pC);
    [m,n] = max(count);
    Predictlabel_C = label_pC(n);
    for n=1:length(image_n)
        Num1 = find(strcmp(dataN,image_n{n}));
        weightN((n-1)*35+1:n*35,:) = probs_normal(Num1,:); 
        pred_LabelN((n-1)*35+1:n*35,:) = YPred_normal(Num1,:);
        true_LabelN((n-1)*35+1:n*35,:) = YLabel_normal(Num1,:);
    end 
%     [pred2model_LabelN] = model2Label(image_n,dataN,'normal');
%     pred_LabelN(35*length(image_n)+1:2*35*length(image_n)) = pred2model_LabelN;
    TrueLabelN = unique(true_LabelN);
    [label_pN ia ic] = unique(pred_LabelN);
    countN = hist(pred_LabelN,label_pN);
    [m1,n1] = max(countN);
    Predictlabel_N = label_pN(n1);
    
    [h(i,:),p_value(i,:)]=ttest2(weightC,weightN,0.05); 
    if length(TrueLabelC)==1
        TrueLabel(i,1) = cellstr(TrueLabelC); 
    else
        TrueLabel(i,1) = cellstr(strjoin(cellstr(TrueLabelC),';'));
    end
    TrueLabel(i,2) = cellstr(TrueLabelN);
    PredictLabel(i,1) = Predictlabel_C;     PredictLabel(i,2) = Predictlabel_N;
    weightC = []; weightN = [];
    clear pred_LabelN true_LabelN pred_LabelC true_LabelC 
    
    if ~isequal(cellstr(Predictlabel_C),cellstr(Predictlabel_N))
        location_flag(i,1) = 1;
    else
        location_flag(i,1) = 0;
    end
end
numID = find(location_flag==1);
proteinID = antibody_ids(numID);
H = h(numID,:);
P_value = p_value(numID,:);
label_predict = PredictLabel(numID,:);
label_true = TrueLabel(numID,:);

