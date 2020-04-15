function [clabels] = images_Labels(images)
load('ID_Labels.mat');
% load('images.mat');
[m n] = size(images);
clabels = cell( n , 1);
for i=1:length(images)
    picture = images{i};
    ind = strfind(picture,'\');
    id = picture(ind(2)+1:ind(3)-1);
    idex = find(strcmp(antibody_ids,id));
    tissue_id = picture(ind(3)+1:ind(4)-1);
    if strcmp(tissue_id,'normal')
        clabels(i) = classlabels_n(idex);
    else
        clabels(i) = classlabels_c(idex);
    end
end
ind0 = find(strcmp(clabels,'cytoplasmic/membranous'));
clabels(ind0) = cellstr('1');
ind1 = find(strcmp(clabels,'nuclear'));
clabels(ind1) =cellstr( '2');
clabels = cell2mat(clabels);
clabels = str2num(clabels);