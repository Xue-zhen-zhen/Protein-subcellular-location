function  feat = addlbpfeat(imgPath_i, sepaPath_i, numPoints, sizePatch ,Region_coord,feats592_PNAS)
% calcufeat LBP features
I = imread(imgPath_i);               
load(sepaPath_i,'W');       
I = CleanBorders(I);
I_unmixed = linunmix(I,W);
prot= I_unmixed(:,:,2);
nuc = I_unmixed(:,:,1);
radius = (sizePatch-1)/2;

feat.centers_PNAS = Region_coord;

knownNumPoints = 0;
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
            %             feats1_field = zeros(1,592);
            feats1_field = zeros(1,256);
        else
            % CALCULATE LBP FEATURES
%             [feats1_field, ~] = Calculate_image(nuc_field, prot_field);
            spoints = [1, 0; 1, -1; 0, -1; -1, -1; -1, 0; -1, 1; 0, 1; 1, 1];
            feats1_field = lbp(prot_field,spoints,0,'h');
        end
    else
        indempty = [indempty iR];
%         feats1_field = zeros(1,592);
        feats1_field = zeros(1,256);
    end
    feats592_PNAS(iR,593:848) = feats1_field;
end 
feat.feats848_PNAS = feats592_PNAS;