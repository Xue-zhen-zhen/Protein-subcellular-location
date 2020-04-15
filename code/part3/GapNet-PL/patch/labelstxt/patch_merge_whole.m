function [accuracy_whole,accuracy_test_whole,recall_whole,precision_whole ,F1_score_whole]=patch_merge_whole(imdsValidation,YValidation,YPred)
% load('patchlabel_googlenet_35_0.002_(90.9).mat');
data_Validation = imdsValidation.Files;
data0 = cell(length(data_Validation),1);
for i=1:length(data_Validation)
    I = data_Validation{i};
    idex0=strfind(I,'\');
    idex1=strfind(I,'(');
    data0(i) = cellstr(I(idex0(end)+1:idex1-2));
end
[data ia ic] = unique(data0);

for j=1:length(data)
    idex = find(strcmp(data0,data(j)));
    idex_YV = YValidation(idex);
    idex_YP = YPred(idex);
    validation_label(j,1) = unique(idex_YV);
    [label_p ia1 ic1] = unique(idex_YP);
    count = hist(idex_YP,label_p);
    [m,n] = max(count);
    predict_label(j,1) = label_p(n);
end
accuracy_whole = mean(predict_label == validation_label);
[accuracy_test_whole,recall_whole,precision_whole ,F1_score_whole] = evaluate(predict_label,validation_label);