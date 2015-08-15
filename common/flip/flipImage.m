function [img,shape]=flipImage(img,shape)
%本函数可以用来翻转图片和特征点，下面给出了载入特征点和写入图片的方法
%shape=annotation_load('*.pts','w300');%载入shape
%img=imread('*.png');
%imwrite(imgmat,'*.png');%写入图片
%./common/io/write_w300_shape.m介绍了如何把shape写到文件中。
%flip image & shape
if size(img,3) > 1
    img_gray   = fliplr(rgb2gray(uint8(img)));
else
    img_gray   = fliplr(img);
end

if 0
    disp('before flipping...');
    figure(1); imshow(img); hold on;
    draw_shape(shape(:,1),...
        shape(:,2),'r');
    hold off;
   % pause;
end
clear img;
img = img_gray;
clear img_gray;

shape = flipshape(shape);
shape(:,1) = size(img,2)+1 - shape(:, 1);


if 0
    disp('after flipping...');
    figure(1); imshow(img); hold on;
    draw_shape(shape(:,1),...
        shape(:,2),'y');
    hold off;
   % pause;
end