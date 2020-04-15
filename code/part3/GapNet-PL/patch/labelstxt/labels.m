% truth = importdata('./perimage/12024000_samples-labels.txt');
% predict = importdata('./perimage/12024000_samples-predictions.txt');
truth = importdata('./perprotein/12040000_samples-labels.txt');
predict = importdata('./perprotein/12040000_samples-predictions.txt');
predict_label = zeros(size(predict,1),3);
for i=1:size(predict,1)
    A=predict(i,:);
    MAX=max(A);
    for j=1:length(A)
        if A(j)<MAX
            predict_label(i,j)=0;
        else
            predict_label(i,j)=1;
        end
    end
end
ind0_p = find(predict_label(:,1)==1);     ind0_t = find(truth(:,1)==1);
ind1_p = find(predict_label(:,2)==1);     ind1_t = find(truth(:,2)==1);
ind2_p = find(predict_label(:,3)==1);     ind2_t = find(truth(:,3)==1);
truth_label = zeros(2,size(predict,1));
predlabels = zeros(2,size(predict,1));
truth_label(1,ind0_t)=1;  truth_label(:,ind1_t)=1;  truth_label(2,ind2_t)=1;
predlabels(1,ind0_p)=1;   predlabels(:,ind1_p)=1;   predlabels(2,ind2_p)=1;
subset_accuracy = S_accuracy(predlabels,truth_label);
[accuracy_test,recall,precision,F1_score] = Accuracy(predlabels,truth_label);

% merge whole image
% load('./resnet18_35.mat','imdsValidation');
% load('./googlenet.mat','imdsValidation');
load('resnet18.mat', 'imdsValidation')
YValidation = imdsValidation.Labels;
a=cell(size(predict,1),1);  YPred=cell(size(predict,1),1);
a(ind0_p)=cellstr('Cytoplasmic&membranous');
a(ind1_p)=cellstr('Cytoplasmic&membranous&nuclear');
a(ind2_p)=cellstr('Nuclear');
% YPred(1:1753)=a(918:end);   %需手动选择
% YPred(1754:2201)=a(470:917);
% YPred(2202:end)=a(1:469);
% YPred(1:1750)=a(876:end);   %需手动选择
% YPred(1751:2170)=a(456:875);
% YPred(2171:end)=a(1:455);
YPred(1:1540)=a(1086:end);   %需手动选择
YPred(1541:2205)=a(421:1085);
YPred(2206:end)=a(1:420);
YPred = categorical(YPred);
[accuracy_whole,accuracy_test_whole,recall_whole,precision_whole ,F1_score_whole]=patch_merge_whole(imdsValidation,YValidation,YPred);


% three
truth_label_three = zeros(3,size(predict,1));
predlabels_three = zeros(3,size(predict,1));
truth_label_three(1,ind0_t)=1;  truth_label_three(2,ind1_t)=1;  truth_label_three(3,ind2_t)=1;
predlabels_three(1,ind0_p)=1;   predlabels_three(2,ind1_p)=1;   predlabels_three(3,ind2_p)=1;
subset_accuracy_three = S_accuracy(predlabels_three,truth_label_three);
[accuracy_test_three,recall_three,precision_three,F1_score_three] = Accuracy(predlabels_three,truth_label_three);