function [TrainID_post] = IDsplitperprotein(id,Protein,perproteinID,protein)
m=0;
for g=1:size(Protein,1)
    ind0 = find(id==Protein(g,1));
    [r,c] = size(ind0);
    if r>1
        TrainID(m+1:m+r,1) = perproteinID(ind0);
        Label(m+1:m+r,1) = protein(ind0,4);
    else
       TrainID(m+1,1) = perproteinID(ind0);
       Label(m+1,1) = protein(ind0,4);
    end
    [m,n] = size(TrainID);
end
ind = find(strcmp(cellstr(Label),'cytoplasmic/membranous'));
ind1 = find(strcmp(cellstr(Label),'cytoplasmic/membranous,nuclear'));
ind2 = find(strcmp(cellstr(Label),'nuclear'));
label(ind,1) = 1; label(ind1,1) = 2; label(ind2,1) = 3;
TrainID_post = unique(TrainID);
for i=1:length(TrainID_post)
    index = find(TrainID==TrainID_post(i));
    label_post = label(index);
    IDlabel = unique(label_post);
    TrainID_post(i,2) = IDlabel;
end