function  didwget = TOwholesets_cancerimage(path,writePATH)
% path = '.\part1\data\1_images\';
list = dir(fullfile(path));
for j=3:size(list,1)
    I_path = [path '\' list(j).name '\cancer\colorectal cancer\'];
    writepath = writePATH;
    imgDir = dir([I_path '*.jpg']);
    if isempty(imgDir)
        error('this antibodyID no images');
    else
        for i=1:length(imgDir)
            index = strfind(imgDir(i).name,'_');
            Lable = imgDir(i).name(1:index(1)-1);
            if strcmp(Lable,'CM')
                WritePath = [writepath 'CM\'] ;
                if ~exist(WritePath,'dir')
                    mkdir(WritePath);
                end
                Imagepath = [WritePath imgDir(i).name];
                if ~exist(Imagepath,'file')
                    I = imread(image_ur);
                    imwrite(I,Imagepath);
                end
            elseif strcmp(Lable,'N')
                WritePath = [writepath 'N\'] ;
                if ~exist(WritePath,'dir')
                    mkdir(WritePath);
                end
                Imagepath = [WritePath imgDir(i).name];
                if ~exist(Imagepath,'file')
                    I = imread(image_ur);
                    imwrite(I,Imagepath);
                end
            elseif strcmp(Lable,'CMN')
                WritePath = [writepath 'CMN\'] ;
                if ~exist(WritePath,'dir')
                    mkdir(WritePath);
                end
                Imagepath = [WritePath imgDir(i).name];
                if ~exist(Imagepath,'file')
                    I = imread(image_ur);
                    imwrite(I,Imagepath);
                end
            end
        end
    end
end
 didwget=1; 