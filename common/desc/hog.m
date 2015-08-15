function desc = hog( im, pos , lmsize )


%fsize  = sqrt(norm_size);
%lmsize  = fsize;
%gsize = options.canvasSize(1) * options.descScale(1);

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

%disp([size(cropim) lmsize]);

if size(cropim,1) ~= lmsize || size(cropim,2) ~= lmsize
     cropim = imresize(cropim,[lmsize lmsize]);
end

%cellSize = 32;
cellSize=round(lmsize/2);
%tmp = vl_hog(single(cropim), cellSize, 'verbose');
tmp = vl_hog(single(cropim), cellSize);

if 0
   figure(2); imshow(tmp);
   pause;
end

%desc = feat_normalize(tmp(:));
desc = tmp(:);
     
end