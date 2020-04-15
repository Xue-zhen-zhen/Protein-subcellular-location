function wfeat = tissueFeatures( prot, dna, dbtype, NLEVELS,feattype)
% TISSUEFEATURES   Extract tissue features from unmixed image
%    FEAT = TISSUEFEATURES( prot, dna, DBTYPE, NLEVELS) 
%    calculates 839 morphological and wavelet texture features.计算839个形态和小波纹理特征
%    I is the protein image, J is the nuclear image, DBTYPE //I是蛋白质图像，J是细胞核图像，DBTYPE是用于小波分解的滤波器类型，NLEVELS是分解级别的数量。
%    is the type of filter that should be used for the wavelet
%    decomposition, and NLEVELS is the number of decomposition 
%    levels.
% 
%    Inputs values are: 
%    prot = graylevel, uint8 protein image
%    dna = graylevel, uint8 nuclear image
%    DBTYPE = 'db1',db2',..., or 'db10'
%    NLEVELS = 1,2..., whatever is allowed by image dimensions.
%         A value of 10 is typically used
% 


% BG subtraction by most-common-pixel
[c b] = imhist(prot);
[a i] = max(c);
prot = prot - b(i);

[c b] = imhist(dna);
[a i] = max(c);
dna = dna - b(i);

% Threshold by Otsu's method
thr_prot = graythresh(prot)*255;
thr_dna = graythresh(dna)*255;

obj_prot = prot>thr_prot;
obj_dna = dna>thr_dna;

S = size(prot);
% Feat1: ratio of areas
area_prot = sum(obj_prot(:));
area_dna = sum(obj_dna(:));
% rel_area_prot=area_prot / (S(1)*S(2));
SLFareaRatio = area_prot / area_dna;

% p1 = prot - thr_prot;
% E = edge( p1, 'canny');
% efeat1 = sum(E(:)) / area_prot; % ratio above threshold pixels along edge to above threshold pixels 沿边缘高于阈值像素到高于阈值像素的比率
% efeat2 = sum( p1(E(:))) / sum( p1(:)); % ratio fluorescence along edge to total fluorescence 沿边缘荧光与总荧光的比值

overlap = obj_prot & obj_dna;
areaOverlap = sum(overlap(:));
SLFoverlapRatio = areaOverlap / area_prot;

SLFoverlapIntRatio = sum(prot(overlap)) / sum(prot(:));

dist_dna = bwdist(obj_dna);
SLFdistance = sum(dist_dna(obj_prot))/area_prot;

% ofeat = [rel_area_prot SLFareaRatio SLFoverlapRatio SLFoverlapIntRatio SLFdistance efeat1 efeat2];
ofeat = [area_prot SLFareaRatio SLFoverlapRatio SLFoverlapIntRatio SLFdistance];
clear dist_* obj_ overlap dna*

prot = single(prot);
%计算LBP特征
if strcmp(feattype,'SLFs_LBPs')
   spoints = [1, 0; 1, -1; 0, -1; -1, -1; -1, 0; -1, 1; 0, 1; 1, 1];
   lbpfeat=lbp(prot,spoints,0,'h');
end

GLEVELS = 31;
A = uint8(round(GLEVELS*prot/max(prot(:))));

wfeat = ml_texture( A);
wfeat = [mean(wfeat(1:13,[1 3]),2); mean(wfeat(1:13,[2 4]),2)]';

[C,S] = wavedec2(prot,NLEVELS,dbtype);

for k = 0 : NLEVELS-1
    [chd,cvd,cdd] = detcoef2('all',C,S,(NLEVELS-k));
    A = chd - min(chd(:));
    A = uint8(round(GLEVELS*A/max(A(:))));
    hfeat = ml_texture( A);
    hfeat = [mean(hfeat(1:13,[1 3]),2); mean(hfeat(1:13,[2 4]),2)]';

    A = cvd - min(cvd(:));
    A = uint8(round(GLEVELS*A/max(A(:))));
    vfeat = ml_texture( A);
    vfeat = [mean(vfeat(1:13,[1 3]),2); mean(vfeat(1:13,[2 4]),2)]';

    A = cdd - min(cdd(:));
    A = uint8(round(GLEVELS*A/max(A(:))));
    dfeat = ml_texture( A);
    dfeat = [mean(dfeat(1:13,[1 3]),2); mean(dfeat(1:13,[2 4]),2)]';

    wfeat = [wfeat hfeat vfeat dfeat ...
        sqrt(sum(sum(chd.^2))) ...
        sqrt(sum(sum(cvd.^2))) ...
        sqrt(sum(sum(cdd.^2)))];
end
if strcmp(feattype,'SLFs')
   wfeat = [ ofeat wfeat];
end

if strcmp(feattype,'SLFs_LBPs')
   wfeat = [ ofeat wfeat lbpfeat];
end
% wfeat = [ofeat wfeat lbpfeat];

return

