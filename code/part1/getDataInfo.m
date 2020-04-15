function [result,classlabels] = getDataInfo()
if exist('./IDandlabels.mat','file')
    load('IDandlabels.mat');
    return
end    

a = importdata('.\data0\1_imageInfo_colon_glandularcells.xlsx') ;
imglist = dir('.\data0\1_colon_glandularcells\*.jpg');
% [filename, pathname] = uigetfile('*.jpg', 'E:\MatlabWorks\work1_learnMatlab\data0\1_colon_glandularcells','MultiSelect','on');%
% RFfilepath=pathname;
% addpath(genpath(RFfilepath));
ImageNum=size(imglist,1);  %
ImageNum2=size(a.textdata,1);  %
result1=cell(ImageNum,1);
result2=cell(1,ImageNum);
y=cell(1,ImageNum);
for i=1:ImageNum %763
    for j=2:ImageNum2 %1076
        Im1=imglist(i).name;%
%       Im1= char(Im1(1,i));
        Im2=char(a.textdata(j,2));
        if strcmp(Im1,Im2)
            y{i} = char(a.textdata(j,6));%
            tempname=char(a.textdata(j,1));
            Num=strfind( tempname,'_');     %
            result1(i)=cellstr(tempname);
            result2(i)=cellstr(tempname(Num(end-3)-5:Num(end-3)-1));%
            if ~exist(['./data/1_images/' result2{i} '\normal\colon\'],'dir')
                mkdir(['./data/1_images/' result2{i} '\normal\colon\']);
            end
            file_path =  './data0/1_colon_glandularcells/';
            Image=imread(strcat(file_path,Im1));
            ImagepathTemp=['.\data\1_images\' char(result2(i)) '\normal\colon\'];
            Imagepath=strcat(ImagepathTemp, Im1);
            imwrite(Image,Imagepath);
            break
        end
    end 
end
% classlabels = cell(1,328);
result2(1:134)=[];
y(1:134)=[];
[result,ia,ic] = unique(result2);
classlabels = cell(1,length(result));
locaia = num2str(ia);
for k=1:length(result)
    L=char(locaia(k,1:3));
    lab=str2num(L);
    classlabels{k} = char(y(1,lab));
end
    
 save('./IDandlabels.mat','result','classlabels');

