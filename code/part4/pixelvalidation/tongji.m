c=0;
load('biomarker2dataEUC.mat')
for i=1:length(dist)
    [m,n]=size(dist{i});
    C(c+1:c+m,1) = dist{i};
    [c,n1] = size(C);
end
hist(C);
 