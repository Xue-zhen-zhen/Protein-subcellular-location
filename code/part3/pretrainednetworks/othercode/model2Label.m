function [pred_LabelC] = model2Label(image_c,dataC,method)
if strcmp(method,'cancer')
    load('.\patchttest\73IDresnet101\biomarker_cancer.mat'); YLabel_cancer = YLabel;
    for c=1:length(image_c)
        Num = find(strcmp(dataC,image_c{c}));
        weightC((c-1)*35+1:c*35,:) = probs_cancer(Num,:);
        pred_LabelC((c-1)*35+1:c*35,:) = YPred_cancer(Num,:);
        true_LabelC((c-1)*35+1:c*35,:) = YLabel_cancer(Num,:);
    end
elseif strcmp(method,'normal')
    load('.\patchttest\73IDinceptionv3\biomarker_normal.mat'); YLabel_normal = YLabel;
    for c=1:length(image_c)
        Num = find(strcmp(dataC,image_c{c}));
        weightC((c-1)*35+1:c*35,:) = probs_normal(Num,:);
        pred_LabelC((c-1)*35+1:c*35,:) = YPred_normal(Num,:);
        true_LabelC((c-1)*35+1:c*35,:) = YLabel_normal(Num,:);
    end
end