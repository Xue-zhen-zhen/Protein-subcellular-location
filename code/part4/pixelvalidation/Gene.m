[num,txt]=xlsread('./Excel/biomarker2.xlsx');
[m,n] = find(num==1); 
biomarkerGene = txt(unique(m));
txt(unique(m))=[]; NotbiomarkerGene = txt;
% save('./matfile/literGene.mat','biomarkerGene','NotbiomarkerGene')
save('./matfile/biomarker2Gene.mat','biomarkerGene','NotbiomarkerGene')