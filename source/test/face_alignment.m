function shape = face_alignment( ShapeModel, DataVariation,...
    LearnedCascadedModel, Data, img, shape, options )



%% setup the fixed parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nData = length(Data);
shapeDim = size(ShapeModel.MeanShape,1);
n_init_randoms_test = options.n_init_randoms_test;

MeanShape2 = vec_2_shape(ShapeModel.MeanShape);

aligned_shape = zeros(n_init_randoms_test,shapeDim);

%% detect the face region using face detectors or ground-truth %%%%%%%%%%%%
%% if using ground-truth
bbox = [];

if isempty(bbox)
    %% if using ground-truth
    bbox = getbbox(shape);
end

%% randomize n positions for initial shapes
[rbbox] = random_init_position( ...
    bbox, DataVariation, n_init_randoms_test );

%% randomize which shape is used for initial position
rIdx = randi([1,nData],n_init_randoms_test);

%% iterations of n initial points %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for ir = 1 : n_init_randoms_test
    
    %% get random positions and inital shape indexs
    idx    = rIdx(ir);
    init_shape = Data(idx).shape; %% get randomly shape from others
    cbbox  = rbbox(ir,:);
    
    %init_shape = resetshape(cbbox, init_shape);
    init_shape = resetshape(cbbox, MeanShape2);
    
    %% detect landmarks using cascaded regression
    aligned_shape(ir,:) = cascaded_regress( ShapeModel, ...
        LearnedCascadedModel, img, init_shape, options );
    
    
    
end

if n_init_randoms_test == 1
    shape = vec_2_shape(aligned_shape');
else
    shape = vec_2_shape(mean(aligned_shape)');
end

end
