function [drawRectangleImage] = drawRectangleFrame(image,x_coordinate,windowSize)
[row,col,n] = size(image);  % ����ͼ��ߴ�
height = windowSize(1);  %���ο�ߴ磬���ʽΪ[height,width]����[�߶�,���]
width = windowSize(2);
figure;imshow(image);
for i=1:size(x_coordinate,1)
    x = x_coordinate(i,1);
    y = x_coordinate(i,2);
    if((x<=row && y<=col)&&(height<=row && width<=col))
        disp('���ο�Ϸ���');
        hold on
        drawRectangleImage = rectangle('Position',[y,x,width,height],'EdgeColor','r');
        hold off
    else
        disp('���ο򲻺Ϸ���');
    end
end

