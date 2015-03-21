function [shape,img] = normalize_rest_shape ( ref, data, options )

cvw = options.canvasSize(1);
cvh = options.canvasSize(2);

base = ref.shape;

shape = data.shape;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Use procrustes analysis to align shape.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[d, z, tform] = procrustes(base, shape, 'Reflection',false);

%% normaling shape %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
debug = 0;

if debug
    
    Trans = -1/tform.b*tform.c*tform.T';
    Trans = Trans(1, :);
    
    transM = [1/tform.b*tform.T Trans'];
    cvXY   = [1 cvw 1 cvw;
        1 1 cvh cvh];
    
    img       = im2double(rgb2gray(imread(data.img)));
    normImg   = quad2Box(img, cvXY, transM);
    
    figure(1);
    imshow(normImg);
    hold on;
    plot(z(:, 1), z(:, 2), 'r.');
    pause;
    
end

shape = z;

end