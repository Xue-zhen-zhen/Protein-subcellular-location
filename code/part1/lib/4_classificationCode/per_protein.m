function [idlabels] = per_protein(alabels)
a=importdata('data.xlsx');
protein = cell(size(a,1)-1,2);
for i=2:size(a,1)
    I = a{i,1};
    idex0=strfind(I,'/');
    idex1=strfind(I,'_');
    protein(i-1,1)= cellstr(I(idex0(end)+1:idex1(5)-1));
    protein(i-1,2)= cellstr(I(idex1(5)+1:idex1(6)-1));
    protein(i-1,3) = cellstr(I(idex1(6)+4:idex1(7)-1));
end
[b,ia,ic]=unique(protein(:,1));
% for j=1:length(b)
%     b(j,2)=protein(ia(j),2);
% end
perproteinID = transpose(str2num(cell2mat(protein(:,3)))');
indices_perprotein = crossvalind('Kfold',b(1:length(b),1),10);
for k=1:length(b)
    ind = find(strcmp(protein(:,1),b{k,1}));
    perproteinID(ind,2) = indices_perprotein(k);
end
c=unique(perproteinID(:,1));
for j=1:length(c)
    index1 = find(perproteinID(:,1)==c(j));
    index2 = find(alabels(:,1)==c(j));
    idlabels(index2,1)=perproteinID(index1,2);
end
