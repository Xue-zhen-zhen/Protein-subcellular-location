function didwget = downloadimages(DataInfo,Path,datatype)
% clear all;clc;
% load('LiteratureDataInfo.mat')
ProteinSIQL = DataInfo;
[Gene,ia,ic]=unique(ProteinSIQL(1:end,1));
for i=1:length(Gene)
    url = ['http://v19.proteinatlas.org/' char(Gene(i,1)) '.xml'];
    [fileurl,st] = urlread(url);
    index = find(strcmp(ProteinSIQL(1:end,1),Gene{i}));
    for j=1:length(index)
        antibodyID = ProteinSIQL{index(j),3};
%         location = ProteinSIQL{index(j),7};
        antibodyid = str2num(antibodyID(4:end));
        find0 = strfind(fileurl,['<antibody id="' antibodyID '"']);
        find1 = strfind(fileurl(find0:end),'</antibody>');
        antibodyIDrange = fileurl(find0:find1(1)+find0-1);
        index_normal = strfind(antibodyIDrange,'<tissue organ="Gastrointestinal tract" ontologyTerms="UBERON:0001155">Colon</tissue>');
        index_cancer = strfind(antibodyIDrange,'<tissue organ="Gastrointestinal tract">Colorectal cancer</tissue>');
        if ~isempty(index_cancer) && ~isempty(index_normal)
            rang_data = strfind(antibodyIDrange(index_normal:end),'</data>');
            rang_normaltissue = antibodyIDrange(index_normal:rang_data(1)+index_normal-1);
            pathImg_0 = [Path '/1_images/' num2str(antibodyid)];
            rang_data_cancer = strfind(antibodyIDrange(index_cancer:end),'</data>');
            rang_cancer = antibodyIDrange(index_cancer:rang_data_cancer(1)+index_cancer-1);
            location_cancer_0 = strfind(rang_cancer,'<patient>');
            location_cancer_1 = strfind(rang_cancer,'</patient>');
            for g=1:length(location_cancer_0)
                location_range = rang_cancer(location_cancer_0(g):location_cancer_1(g));
                location_numbercancer0 = strfind(location_range,'<location>');
                location_numbercancer1 = strfind(location_range,'</location>');
                cancer_location0 = location_range(location_numbercancer0+10:location_numbercancer1-1);
                if strcmp(cancer_location0,'cytoplasmic/membranous')
                    cancer_location0 = 'CM';
                elseif strcmp(cancer_location0,'nuclear')
                    cancer_location0 = 'N';
                elseif strcmp(cancer_location0,'cytoplasmic/membranous,nuclear')
                    cancer_location0 = 'CMN';
                else
                    error('none');
                end
                pathImg_c = [pathImg_0 '/cancer/colorectal cancer/'];
                if ~exist(pathImg_c,'dir')
                    mkdir(pathImg_c);
                end
                image_0 = strfind(location_range,'<imageUrl>');
                image_1 = strfind(location_range,'</imageUrl>');
                for k=1:length(image_0)
                    image_ur = location_range(image_0(k)+10:image_1(k)-1);
                    id = strfind(image_ur,'/');
                    image_name = image_ur(id(end)+1:end);
                    Imagepath = [pathImg_c '/' cancer_location0 '_' image_name];
                    if exist(Imagepath,'file')
                        continue
                    else
                        I = imread(image_ur);
                        imwrite(I,Imagepath);
                    end
                end
            end
            if exist([pathImg_0 '/cancer'],'dir')
                imgDir  = dir([pathImg_c '*.jpg']);
                if ~isempty(imgDir)
                    pathImg_n = [pathImg_0 '/normal/colon'];
                    [imgFlag] = downloadIHC_n (rang_normaltissue, pathImg_n);
                end
            end
        end
    end
end
didwget=1;