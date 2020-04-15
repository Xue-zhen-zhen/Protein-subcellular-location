function  didwget = TOwholesets(PATH,Writepath)
% path = '.\part1\data\1_images\';
list = dir(fullfile(PATH));
for j=3:size(list,1)
    I_path = [PATH '\' list(j).name '\normal\colon\'];
    writepath = Writepath;
    imgDir = dir([I_path '*.jpg']);
    if isempty(imgDir)
        error('this antibodyID no images,please delete');
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