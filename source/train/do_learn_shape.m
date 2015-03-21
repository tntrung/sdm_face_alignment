function do_learn_shape ( options )

%% locating data folders %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
imageDataPath = options.trainingImageDataPath;
truthDataPath = options.trainingTruthDataPath;

%% loading training data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Data = load_data( imageDataPath, truthDataPath, options );

%% normalizing training data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Data = normalize_data( Data, options );

%% shape model training %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ShapeModel = build_shape_model( Data );

if ~exist( options.modelPath , 'dir' )
    mkdir( options.modelPath );
end

save([options.modelPath options.slash options.datasetName ...
    '_ShapeModel.mat'], 'ShapeModel');

clear Data;
clear ShapeModel;

