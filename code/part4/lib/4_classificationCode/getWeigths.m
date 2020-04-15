function [W_n,W_c] = getWeigths(alabels,images,weights,clabels,predlabels)
load('ID_Labels.mat','antibody_ids');
W_n =zeros(1,3);
[m1,n1]=size(W_n);
W_c =zeros(1,3);
[m2,n2]=size(W_c);
for i=1:length(antibody_ids)
    ID =antibody_ids{i};
    ind = find(alabels==str2num(ID));
    Image = images(ind);
    for j=1:length(Image)
        picture = Image{j}; 
        index = strfind(picture,'\');
        tissue_id = picture(index(3)+1:index(4)-1);
        if strcmp(tissue_id,'normal')
            W_n(m1+1,1:3) = weights(ind(j),:);
            W_n(m1+1,4) = clabels(ind(j));
            W_n(m1+1,5) = predlabels(ind(j));
            [m1,n1]=size(W_n);
        else
           W_c(m2+1,1:3) = weights(ind(j),:);
           W_c(m2+1,4) = clabels(ind(j));
           W_c(m2+1,5) = predlabels(ind(j));
           [m2,n2]=size(W_c);
        end
    end
end