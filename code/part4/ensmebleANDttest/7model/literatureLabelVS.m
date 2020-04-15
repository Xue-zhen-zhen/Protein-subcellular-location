Protein = importdata('./excel/data2.xlsx');
Protein(1,:)=[];
load('liter(2).mat');
antibody_ids={'39238','39239','1962','9672','27247','21888','6881','108','1950','29159',...
'29160','5868','20043','443','42282','16682','10546','1671','58603','68241',...
'68242','3844','16290','43135','25753','3843','28992','28993','15055','61646',...
'68177','68178','3','5256','46298','4435','7644','16225','5072','29722',...
'29723','70249','2891','3765'}';
ProteinSIQL(:,8)=antibody_ids;
load('.\4_classification\literatureclassresult\predict\googlenet\cancer\lin_db4_75_205\cytoplasmic&membranous_cytoplasmic&membranous&nuclear_nuclear.mat')
testlabel = cell(size(predlabels,1),1);
for i=1:size(Protein,1)
    ind = find(strcmp(ProteinSIQL(:,1),Protein{i}));
    for j=1:length(ind)
        ID = str2num(ProteinSIQL{ind(j),8});
        ind1 = find(alabels==ID);
        testlabel(ind1,1) = Protein(i,3);
    end
end
clabels_test = zeros(size(testlabel,1),1);
index2 = find(strcmp(testlabel,'Cytoplasmic&membranous'));
index3 = find(strcmp(testlabel,'Cytoplasmic&membranous&nuclear'));
index4 = find(strcmp(testlabel,'Nuclear'));
clabels_test(index2)=1;  clabels_test(index3)=2; clabels_test(index4)=3;
accuracy=size(find( clabels_test == predlabels))/size(predlabels);

