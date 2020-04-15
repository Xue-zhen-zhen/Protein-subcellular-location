function [idx_sda_12,traindata_12,testdata_12] = feat_12(traindata_12,testdata_12,trainlabels_12,writepath)
[traindata,testdata] = featnorm( traindata_12, testdata_12);
traindata_12 = double( traindata*2-1);
testdata_12 = double(testdata*2-1);

u = unique( trainlabels_12);
feat = []; feat{length(u)} = [];
for i=1:length(u)
    feat{i} = traindata_12( trainlabels_12==u(i), :);% 5:end);
end
finalwritepath=writepath;    
finalwritepath((finalwritepath == ',')|(finalwritepath == '/')) = '&';   
logfilename = [finalwritepath '_sda_12log.txt'];      
idx_sda_12 = ml_stepdisc( feat,logfilename);