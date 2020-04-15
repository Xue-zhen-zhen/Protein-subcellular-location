function [drawRectangleImage] = drawRectangleFrame(image,x_coordinate,windowSize)
[row,col,n] = size(image);  % 输入图像尺寸
height = windowSize(1);  %矩形框尺寸，其格式为[height,width]，即[高度,宽度]
width = windowSize(2);
figure;imshow(image);
for i=1:size(x_coordinate,1)
    x = x_coordinate(i,1);
    y = x_coordinate(i,2);
    if((x<=row && y<=col)&&(height<=row && width<=col))
        disp('矩形框合法！');
        hold on
        drawRectangleImage = rectangle('Position',[y,x,width,height],'EdgeColor','r');
        hold off
    else
        disp('矩形框不合法！');
    end
end

