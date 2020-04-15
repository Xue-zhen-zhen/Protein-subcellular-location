function [traindata,testdata,idx_sda,Traindata] = SDA(data,ttlist,trainlabels,finalwritepath,k,clabels)

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
logfilename = [finalwritepath '_' k '_sdalog.txt'];
idx_sda = ml_stepdisc( feat,logfilename);

% Train the Model
[model,options] = trainModel(ttlist,traindata,clabels,testdata,idx_sda);
save([finalwritepath(1:end-4) '_' k '_model.mat'],'model','options','Traindata','idx_sda');

index = strfind(finalwritepath,'\');
ModelPath = ['.\part4\model\' finalwritepath(index(6)+1:index(end)-1) k '.mat'];
save(ModelPath,'model','options','Traindata','idx_sda');
