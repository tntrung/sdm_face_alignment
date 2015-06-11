function desc = raw( im, pos , lmsize, norm_size )

lmsize = size(im,1) * scale;
fsize  = sqrt(norm_size);
%lmsize  = fsize;

rect =  [pos(1) - (lmsize-1)/2, ...
         pos(2) - (lmsize-1)/2, ...
         lmsize - 1, lmsize - 1];
     
if 0
   figure(1); imshow(im);hold on;
   %draw_shape(pos(:,1),pos(:,2),'g');
   draw_rect(rect);
   hold off;
   pause;
end

cropim = imcrop(im,rect);

tmp = imresize(cropim,[fsize fsize]);

if 0
   figure(2); imshow(tmp);
   pause;
end

desc = feat_normalize(tmp(:));
     
end