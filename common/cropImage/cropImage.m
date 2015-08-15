function [ img,shape,box,t ] = cropImage( img,shape )
%截取图像中的人脸区域，
%若截取的区域超过图像大小，则使用边界填充
%休正shape,返回box,和灰度图

  
    %% get bounding box
   box= getbbox(shape);
    
    %% enlarge region of face
    region     = enlargingbbox(box, 2.0);

    region_y  = double(max(region(2), 1));
    region_x  = double(max(region(1), 1));
    
 if 0
    disp('before cropping Image...');
    figure(1); imshow(img); hold on;
    draw_shape(shape(:,1),...
        shape(:,2),'r');
    hold on;
    rectangle('Position',  box, 'EdgeColor', 'y');
    rectangle('Position',  region, 'EdgeColor', 'g');
    hold off;
    %pause;
end   

    
   bottom_y   = double(min(region(2) + region(4) - 1, ...
         size(img,1)));
   right_x    = double(min(region(1) + region(3) - 1, ...
       size(img,2))); 
    
    img_region = img(region_y:bottom_y, region_x:right_x, :);
    if size(img_region,3)>1
         img_region=rgb2gray(img_region);
    end
      [M,N]=size(img_region);

    c1=max(1-region(1),0);
    r1=max(1-region(2),0);
  
 %  imshow(img_region);
    img_region= padarray(img_region,[r1,c1],'replicate','pre'); %填充图像，使图像处于正中间，防止某些图像过于靠近左上边界
  
     [M,N]=size(img_region);

    r2=max(region(4)-M,0);
    c2=max(region(3)-N,0);;
    img_region= padarray(img_region,[r2,c2],'replicate','post'); %填充图像，使图像处于正中间，防止某些图像过于靠近右下边界
  %  imshow(img_region);
    
    img=img_region;
    %% recalculate the location of groundtruth shape and bounding box

%     shape = bsxfun(@minus, shape,...
%         double([region_x-c1 region_y-r1]));
    shape = bsxfun(@minus, shape,...
        double([region_x-c1-1 region_y-r1-1]));
    box = getbbox(shape);
    t=[region_x-c1-1 region_y-r1-1];



if 0
    disp('after cropping Image...');
    figure(2); imshow(img); hold on;
    draw_shape(shape(:,1),...
        shape(:,2),'g');
    rectangle('Position',  box, 'EdgeColor', 'r');
    hold off;
    pause;
end




end
function region = enlargingbbox(bbox, scale)

region(1) = floor(bbox(1) - (scale - 1)/2*bbox(3));
region(2) = floor(bbox(2) - (scale - 1)/2*bbox(4));

region(3) = floor(scale*bbox(3));
region(4) = floor(scale*bbox(4));

end
