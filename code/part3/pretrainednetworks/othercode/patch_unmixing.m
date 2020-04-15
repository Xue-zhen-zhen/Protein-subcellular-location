load('Wbasis.mat');
% PathRoot = './Patch_number/number=35/';
PathRoot = 'E:\Deeplearning\Patch_biomarker\literatureData\normal';
list=dir(fullfile(PathRoot));
for i=3:size(list,1)
    sublist=dir([PathRoot '/' list(i).name]);
    writepath = ['./Patch_unmix/literaturedata/normal/'];
    if ~exist(['./Patch_unmix/literaturedata/normal/' ],'dir')
        mkdir (['./Patch_unmix/literaturedata/normal/']);
    end
    for j=3:size(sublist,1)
        imagename = sublist(j).name;
        imagename_n = [imagename(1:end-4) '_' num2str(j-2) '.jpg'];
        Im = [PathRoot '/' list(i).name '/' imagename];
        I = imread(Im);
%         [lei,wei,~] = size(I);
%         if (lei>3000)
%             I = I(floor((lei-3000)/2)+1:floor((lei+3000)/2),floor((lei-3000)/2)+1:floor((lei+3000)/2),:);
%         end
        I = CleanBorders(I);
        I_unmixed = linunmix(I,W);
        if ~exist([writepath imagename_n],'dir')
           imwrite(I_unmixed,[writepath imagename_n]);
        end
    end
end