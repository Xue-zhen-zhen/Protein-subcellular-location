function feat = calcPNASfeat(imgPath_i, sepaPath_i, numPoints, sizePatch, dbtype, NLEVELS) % ,Region_coord,knownFeat
% calculate feat.centers_PNAS and feat.feats592_PNAS features

I = imread(imgPath_i);               
load(sepaPath_i,'W');       
I = CleanBorders(I);
I_unmixed = linunmix(I,W);
prot= I_unmixed(:,:,2);
nuc = I_unmixed(:,:,1);
radius = (sizePatch-1)/2;

% find Patches
if ~exist('Region_coord','var') % no known centers
    knownNumPoints = 0;
    knownFeat = [];
    Region_coord = findPatches(I,prot,nuc,radius,numPoints,[]); 
else
    knownNumPoints = size(Region_coord,1);
    knownCenters = Region_coord;
    Region_coord = findPatches(I,prot,nuc,radius,numPoints,knownCenters); 
    if sum(Region_coord(1:knownNumPoints,:)-knownCenters)~=0
        printf(['warning: interest points donot match' imgPath_i '\n']);
    end
end
feat.centers_PNAS = Region_coord;

% features
indempty = [];
for iR = (knownNumPoints+1):numPoints
    rad_disk = ones(2*radius+1);
    if ~isnan(Region_coord(iR,1) + Region_coord(iR,2))
        cen_x = Region_coord(iR,1);
        cen_y = Region_coord(iR,2);
        range_x = max(1,cen_x-radius):min(size(nuc,1),cen_x+radius);
        range_y = max(1,cen_y-radius):min(size(nuc,2),cen_y+radius);
        rad_disk = rad_disk(1:length(range_x),1:length(range_y));
        
        nuc_field = nuc(range_x,range_y) .* uint8(rad_disk);
        prot_field = prot(range_x,range_y) .* uint8(rad_disk);
        if length(unique(nuc_field))==1 || length(unique(prot_field))==1
            indempty = [indempty iR];
            feats1_field = zeros(1,592);
        else
            % CALCULATE FIELD LEVEL FEATURES
            [feats1_field, ~] = Calculate_image(nuc_field, prot_field);
        end 
    else
        indempty = [indempty iR];
        feats1_field = zeros(1,592);
    end
    feat.feats592_PNAS(iR,:) = feats1_field;
end 
feat.feats592_PNAS(1:knownNumPoints,:) = knownFeat;
feat.feats592_PNAS(indempty,:) = [];
feat.centers_PNAS(indempty,:) = [];