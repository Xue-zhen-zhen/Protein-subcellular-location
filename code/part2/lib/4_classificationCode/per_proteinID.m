function [idlabels] = per_proteinID(alabels)

IDlabels = unique(alabels);
indices_perprotein = crossvalind('Kfold',IDlabels(1:length(IDlabels),1),10);
idlabels = zeros(size(alabels,1),1);
for i=1:length(IDlabels)
    ind = find(alabels==IDlabels(i));
    idlabels(ind,1) = indices_perprotein(i);
end