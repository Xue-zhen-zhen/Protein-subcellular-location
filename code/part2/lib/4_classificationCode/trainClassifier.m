function [model,options] = trainClassifier( trainlabels, traindata)
% TRAINCLASSIFIER   Train a classifier!
%    [MODEL OPTIONS] = TRAINCLASSIFIER( TRAINLABELS, TRAINDATA)
%    trains a SVM classifier (MODEL) on the training data
%    (TRAINDATA) using training labels (TRAINLABELS). OPTIONS
%    is a string that reports what parameters were set for
%    model training. Parameter tuning of C and gamma is done
%    through a simple grid search over a set range.
%
% Last modified Justin Newberg 23 October 2007


% c = 2.^[-5:1:6];  acc_cv = zeros(length(c), 1);
% % Brute force grid search
% for i=1:length(c),
%     tic;
%     options = ['-c ' num2str(c(i)) ' -t 0 -b 0 -v 10'];
%     acc_cv(i) = svmtrain( trainlabels, traindata, options);
%     toc
% end
% 
% [a row] = max(acc_cv);
% 
% options = ['-c ' num2str(c(row)) ' -t 0 -b 1'];  %ÏßÐÔºË
% model = svmtrain( trainlabels, traindata, options);
% 
% 
% return


c = 2.^[-5:1:5];  g = 2.^[-5:1:2];  acc_cv = zeros(length(c),length(g));
% Brute force grid search
for i=1:length(c),
    tic;
    for j=1:length(g),
        options = ['-c ' num2str(c(i)) ' -g ' num2str(g(j)) ' -b 0 -v 10'];
        acc_cv(i,j) = libsvm_svmtrain( trainlabels, traindata, options);
    end
    toc
    disp([i length(c)]);
end

[a,row] = max(acc_cv);
[a ,col] = max(a);
row = row(col);

options = ['-c ' num2str(c(row)) ' -g ' num2str(g(col)) ' -b 1'];   %RBFºË
model = libsvm_svmtrain( trainlabels, traindata, options);

