function [imgFlag] = downloadIHC_n (rang_normaltissue, pathImg_n)
if ~exist(pathImg_n,'dir')
    mkdir(pathImg_n);
end
celltype_0 = strfind(rang_normaltissue,'<cellType>Glandular cells</cellType>');
celltype_1 = strfind(rang_normaltissue(celltype_0:end),'</tissueCell>');
location_cells = rang_normaltissue(celltype_0:celltype_1(1)+celltype_0-1);
location_number0 = strfind(location_cells,'<location>');
location_number1 = strfind(location_cells,'</location>');
location = location_cells(location_number0+10:location_number1-1);
if strcmp(location,'cytoplasmic/membranous')
    tissue_location = 'CM';
elseif strcmp(location,'nuclear')
    tissue_location = 'N';
elseif strcmp(location,'cytoplasmic/membranous,nuclear')
    tissue_location = 'CMN';
else
    error('none');
end

image_0 = strfind(rang_normaltissue,'<imageUrl>');
image_1 = strfind(rang_normaltissue,'</imageUrl>');
for k=1:length(image_0)
    image_ur = rang_normaltissue(image_0(k)+10:image_1(k)-1);
    id = strfind(image_ur,'/');
    image_name = image_ur(id(end)+1:end);
    Imagepath = [pathImg_n '/' tissue_location '_' image_name ];
    if exist(Imagepath,'file')
        continue
    else
        I = imread(image_ur);
        imwrite(I,Imagepath);
    end
end
imgFlag = 1;