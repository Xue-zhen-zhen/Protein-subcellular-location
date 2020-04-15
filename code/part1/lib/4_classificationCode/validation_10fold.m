function [mean_per_evalmodel,indices,W,IMage,PredictLabel]=validation_10fold(ttlist,traindata,clabels,testdata,idx_sda,trainimages,testimages,indices)  %alabels

Data = zeros( size(ttlist,1), size(traindata,2));
Images = cell( size(ttlist,1), 1);
Data(ttlist==1,:)=traindata;
Data(ttlist==2,:)=testdata;
Images(ttlist==1,:)=trainimages;
Images(ttlist==2,:)=testimages;
Data_labels = clabels;
[m,n] = size(Data);
% indices=crossvalind('Kfold',Data(1:m,n),10); % perimage
m=0;
for k=1:10
    test_ind = (indices==k);
    train_ind = ~test_ind;
    train_data = Data(train_ind,:);
    train_label =Data_labels(train_ind);
    train_image = Images(train_ind,:);
    test_data = Data(test_ind,:);
    test_label = Data_labels(test_ind);
    test_image = Images(test_ind,:);
    testTarget = zeros(2,length(test_label));
    preTable = zeros(2,length(test_label));
    
    [model,options] = trainClassifier( train_label,train_data(:,idx_sda));
    [predlabels,accuracy,weights] = svmpredict( test_label,test_data(:,idx_sda), model,'-b 1');
    W(m+1:m+size(test_data,1),:) = weights;
    IMage(m+1:m+size(test_data,1),:) = test_image;
    PredictLabel(m+1:m+size(test_data,1),:) = predlabels;
    [m,N] = size(W);
    
    ind0=find(test_label==1); ind1=find(test_label==2); ind2=find(test_label==3);
    testTarget(1,ind0) = 1;     testTarget(:,ind1)= 1;     testTarget(2,ind2) = 1;
    index0 = find(predlabels==1); index1 = find(predlabels==2); index2 = find(predlabels==3);
    preTable(1,index0)= 1;         preTable(:,index1)=1;         preTable(2,index2)= 1;
    
    subset_accuracy(k) = S_accuracy(preTable,testTarget);
    [accuracy_test(k),recall(k),precision(k),F1_score(k)] = Accuracy(preTable,testTarget);
    [label_accuracy, average_label_accuracy(k)] = L_accuracy(preTable,testTarget);
    prelabel_accuracy(:,k)=label_accuracy;
    weights(:,4)=predlabels;
end
mean_label_accuracy = mean(prelabel_accuracy,2);
eval_classification = [subset_accuracy;accuracy_test;recall;precision;F1_score;average_label_accuracy];
mean_per_evalmodel = mean(eval_classification,2);
