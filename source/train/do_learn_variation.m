function do_learn_variation( options )

%% loading learned shape model
load([options.modelPath options.slash options.datasetName '_ShapeModel.mat']);

imgDir = options.trainingImageDataPath;
ptsDir = options.trainingTruthDataPath;

%% loading data
Data = load_data( imgDir, ptsDir, options );

n = length(Data);

transVec   = zeros(n,2);
scaleVec   = zeros(n,2);

debug = 0;

%% computing the translation and scale vectors %%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i = 1 : n
    
    %% the information of i-th image
    disp(Data(i).img);
    
    img   = imread(Data(i).img);
    shape = Data(i).shape;
    
    %% if detect face using viola opencv
    %boxes = detect_face( img , options );
    
    %% if using ground-truth
    boxes = [];
    
    %% predict the face box
    rect = get_correct_region( boxes, shape, 1 );
    
    %% predict initial location
    [initX,initY,width,height] = init_face_location( rect );
    
    init_shape = align_init_shape(ShapeModel.MeanShape, ...
                                              initX, initY, width, height);
    
    if debug
        figure(1); imshow(img); hold on;
        rectangle('Position',  rect, 'EdgeColor', 'g');
        draw_shape(init_shape.XY(1:2:end), init_shape.XY(2:2:end), 'y');
        draw_shape(shape(:,1), shape(:,2), 'r');
        hold off;
        pause;
    end
    
    [aligned_shape, cropIm] = align_to_mean_shape( ShapeModel, img , ...
        vec_2_shape(init_shape.XY) , options );
    
    [aligned_true_shape] = align_shape(aligned_shape.TransM,shape_2_vec(shape));
        
    if debug
        figure(1); imshow(cropIm); hold on;
        draw_shape(aligned_shape.XY(1:2:end), ...
            aligned_shape.XY(2:2:end), 'y');
        draw_shape(aligned_true_shape(1:2:end), ...
            aligned_true_shape(2:2:end), 'r');
        hold off;
        pause;
    end    
    
    initVector = vec_2_shape(aligned_shape.XY);
    trueVector = vec_2_shape(aligned_true_shape);
    
    %compute mean and covariance matrices of translation.
    meanInitVector  = mean(initVector);
    meanTrueVector  = mean(trueVector);
    
    %compute bounding box size
    initLeftTop     = min(initVector);
    initRightBottom = max(initVector);
    
    initFaceSize = abs(initLeftTop - initRightBottom);
    
    trueLeftTop     = min(trueVector);
    trueRightBottom = max(trueVector);
    
    trueFaceSize = abs(trueLeftTop - trueRightBottom);
    
    transVec(i,:) = (meanInitVector - meanTrueVector)./initFaceSize;
    scaleVec(i,:) = initFaceSize./trueFaceSize;
    
    clear img;
    clear xy;
    
    %    end
    
end

%compute mean and covariance matrices of scale.
[mu_trans,cov_trans] = mean_covariance_of_data ( transVec );
[mu_scale,cov_scale] = mean_covariance_of_data ( scaleVec );

DataVariation.mu_trans  = mu_trans;
DataVariation.cov_trans = cov_trans;
DataVariation.mu_scale  = mu_scale;
DataVariation.cov_scale = cov_scale;

save([options.modelPath options.slash options.datasetName ...
    '_DataVariation.mat'], 'DataVariation');

clear Data;

end