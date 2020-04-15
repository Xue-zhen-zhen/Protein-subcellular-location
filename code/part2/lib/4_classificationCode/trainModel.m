function [model,options] = trainModel(ttlist,traindata,clabels,testdata,idx_sda)
 
Data = zeros( size(ttlist,1), size(traindata,2));
Data(ttlist==1,:)=traindata;
Data(ttlist==2,:)=testdata;
Data_labels = clabels;
[m,n] = size(Data);
[model,options] = trainClassifier( Data_labels ,Data(:,idx_sda));