function [Sxy, cropIm] = align_to_mean_shape(Model, img , xy , options)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. Align to mean shape using procrustes analysis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MeanShape = Model.MeanShape;
NumPts = Model.NumPts;

MeanX = MeanShape(1:2:end);
MeanY = MeanShape(2:2:end);

[d AlignXY tform] = procrustes([MeanX MeanY], xy, 'Reflection',false);

% display_landmark_in_image(img,[MeanX MeanY]); pause;
% display_landmark_in_image(img,xy); pause;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2. Calculate center and transform matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Translatexy = -1/tform.b*tform.c*tform.T';
Translatexy = Translatexy(1, :);

transM = [1/tform.b*tform.T Translatexy'];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3. Calculate bounding rectangle and crop images.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cvw = options.canvasSize(1);
cvh = options.canvasSize(2);

cvXY   = [1 cvw 1 cvw;
          1 1 cvh cvh];

if size(img,3) == 3      
    imgray = im2double(rgb2gray(img));  
else
    imgray = im2double(img);
end

newImage = quad2Box(imgray, cvXY, transM);

if 0
    figure(1);
    imshow(newImage);
    hold on;
    plot(AlignXY(:, 1), AlignXY(:, 2), 'r.');
    pause;
end

Sxy.TransM = transM;
Sxy.XY = zeros(NumPts*2, 1);
Sxy.XY(1:2:end) = AlignXY(:, 1);
Sxy.XY(2:2:end) = AlignXY(:, 2);

cropIm = newImage;

end
