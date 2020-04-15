function [TrainID,TestID] = perproteinsplit()

a=importdata('E:\MatlabWorks\work1_learnMatlab\data.xlsx');
protein = cell(size(a,1)-1,2);
for i=2:size(a,1)
    I = a{i,1};
    idex0=strfind(I,'/');
    idex1=strfind(I,'_');
    protein(i-1,1)= cellstr(I(idex0(end)+1:idex1(5)-1));
    protein(i-1,2)= cellstr(I(idex1(5)+1:idex1(6)-1));
    protein(i-1,3) = cellstr(I(idex1(6)+4:idex1(7)-1));
    protein(i-1,4) = a(i,6);
end
[b,ia,ic]=unique(protein(:,1));
for k=1:length(b)
    P(k,1) = str2num(b{k}(10:end));
end
imageLabel(1:134,1) = 3;  imageLabel(135:262,1) = 2; imageLabel(263:763,1) = 1;  %×¢ÒâimageµÄlabel
for j=1:size(b,1)
    ind = find(strcmp(protein(1:end,1),b{j}));
    Im_label = imageLabel(ind);
    Label = unique(Im_label);
    if length(Label)>1
        count = hist(Im_label,Label);
        [m,n] = max(count);
        P(j,2) = Label(n);
    else
        P(j,2) = Label;
    end
end
[Trainprotein,Testprotein]=divide(P,0.9);
perproteinID = transpose(str2num(cell2mat(protein(:,3)))');
for k=1:size(protein,1)
    id(k,1) = str2num(protein{k,1}(5:end));
end
TrainID = IDsplitperprotein(id,Trainprotein,perproteinID,protein);
TestID = IDsplitperprotein(id,Testprotein,perproteinID,protein);

    