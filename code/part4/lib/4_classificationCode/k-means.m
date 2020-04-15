function [X1,patchtotalfeatures]=k-means(patchpath)
patchtotalfeatures=[];
s_fp1 = zeros(length(patchpath),1); 
for i=1:length(patchpath)
    s_fp1(i) = size(patchpath{i},2);
end
su_fp1 = sum(s_fp1);
cs_fp1 = [0; cumsum( s_fp1)]; cs_fp1( end) = [];
%%%只对当前的db1中的所有特征有效
if exist('./patchtotalfeaturesdb1.mat','file')
    load('patchtotalfeaturesdb1.mat');
else
    for i=1:length(patchpath)
        for j=1:s_fp1(i)
            load( patchpath{i}{j});
            patchfeatures=features.feats592_PNAS;
            patchtotalfeatures=cat(1,patchtotalfeatures,patchfeatures);
        end
    end
    save('./patchtotalfeaturesdb1.mat','patchtotalfeatures');
end
 load('SelectedFeats.mat');
patchtotalfeatures(any(isnan(patchtotalfeatures)'),:)=[];
X=patchtotalfeatures(:,Features);
X(:,any(isnan(X)))=[];
X1=patchtotalfeatures;
[m,n]=size(X1);
opts = statset('Display','final');
[cidx, ctrs] = kmeans(X, 20, 'Distance','sqeuclidean','Start','uniform','Replicates', 1 ,'Options',opts);  % city 
 X1(:,n+1) = cidx;