function [accuracy_test,recall,precision ,F1_score] = evaluate(YPred,YValidation)

preTable = zeros(2,length(YPred));
ValidationTable = zeros(2,length(YPred));

ind0 = find(strcmp(cellstr(YValidation(:,1)),'Cytoplasmic&membranous'));
ind1 = find(strcmp(cellstr(YValidation(:,1)),'Cytoplasmic&membranous&nuclear'));
ind2 = find(strcmp(cellstr(YValidation(:,1)),'Nuclear'));
ValidationTable(1,ind0) = 1;     ValidationTable(:,ind1)= 1;     ValidationTable(2,ind2) = 1;

ind_0 = find(strcmp(cellstr(YPred(:,1)),'Cytoplasmic&membranous'));
ind_1 = find(strcmp(cellstr(YPred(:,1)),'Cytoplasmic&membranous&nuclear'));
ind_2 = find(strcmp(cellstr(YPred(:,1)),'Nuclear'));
preTable(1,ind_0) = 1;     preTable(:,ind_1)= 1;     preTable(2,ind_2) = 1;

[accuracy_test,recall,precision ,F1_score] = Accuracy(preTable,ValidationTable);
