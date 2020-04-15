%function [drawRectangleImage] = drawRectangleFrame(image,x_coordinate,windowSize)
image = imread('E:\works2\work1_learnMatlab\data\1_images\00031\normal\colon\浆膜_208_A_8_3.jpg');
load('.\data\3_features\SLFs\lin_db1_45_25\00031\normal\colon\浆膜_208_A_8_3.mat');
x_coordinate = features.centers_PNAS;
windowSize = [45,45];
[row,col,n] = size(image); % 输入图像尺寸
% x = windowLocation(1);%矩形框位置坐标，其格式为[x,y]
% y = windowLocation(2);
height = windowSize(1);%矩形框尺寸，其格式为[height,width]，即[高度,宽度]
width = windowSize(2);
figure;imshow(image);
for i=1:size(x_coordinate,1)
    x = x_coordinate(i,1)-22;
    y = x_coordinate(i,2)-22;
    if((x<=row && y<=col)&&(height<=row && width<=col))
        disp('矩形框合法！');
        hold on
        drawRectangleImage = rectangle('Position',[y,x,width,height],'EdgeColor','r');
        hold off
    else
        disp('矩形框不合法！');
    end
end

