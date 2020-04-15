sizePatch = 75;
load('Wbasis.mat');
PathRoot = 'C:\Users\hp\Desktop\236\';
list=dir(fullfile(PathRoot));
for i=6:size(list,1)
    writepath = ['C:\Users\hp\Desktop\236\75\'];
    if ~exist(writepath,'dir')
        mkdir(writepath);
    end
    imagename =list(i).name;
    Im = [PathRoot '\' list(i).name];
    I = imread(Im);
    I = CleanBorders(I);
    I_unmixed = linunmix(I,W);
    prot= I_unmixed(:,:,2);
    nuc = I_unmixed(:,:,1);
    radius = (sizePatch-1)/2;
    numPoints =35;
    Region_coord = findPatches(I,prot,nuc,radius,numPoints,[],writepath,imagename);
end