function [shape] = normalize_first_shape( Data, options )

shape = Data.shape;

%% calculating bounding box %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[cropmin,cropmax,offset,minshape,marginW,marginH] = bounding_box ( shape );

%% calculate scale factor %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
W_H = cropmax - cropmin;
wh1 = W_H(1);
wh2 = W_H(2);

CanvasSize = options.canvasSize;

scf = CanvasSize(1)/wh1;
if(scf*wh2 > CanvasSize(2))
    scf = CanvasSize(2)/wh2;
end

%% croping image (for debug only) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
debug = 0;

if debug 
    img = imread(Data.img);
    cropImage   = img(cropmin(2):cropmax(2), cropmin(1):cropmax(1));
    scaleImage  = imresize(cropImage, scf);
end


%% scale shape and image %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
shape = shape - repmat((minshape - [marginW marginH] + offset) ...
    , size(shape, 1), 1);
shape = shape*scf;

if debug
    % Displaying image and feature points.
    figure(1);
    imshow(scaleImage);
    hold on;
    plot(shape(:, 1), shape(:, 2), 'g*');
    pause;
end

end