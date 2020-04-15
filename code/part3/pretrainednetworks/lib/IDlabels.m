function [idlabels] = IDlabels(image)
load('Data.mat');
for i=1:length(images)
    ind = strfind(images{i},'\');
    ImageData{i,1}= images{i}(ind(end)+1:end-4);
end
for j=1:length(image)
    index = find(strcmp(ImageData,image{j}));
    idlabels(j,1) = alabels(index,1);
    idclabelse(j,1) = clabels(index,1);
end