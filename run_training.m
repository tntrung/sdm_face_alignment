function run_training ( )

%% loading the setup %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
options = setup( );

%% learning other requirements %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if options.learningShape == 1
    disp('Learning shap model...');
    do_learn_shape( options );
end

if options.learningVariation == 1
    disp('Learning data variation...');
    do_learn_variation( options );
end

load( ['model/' options.datasetName '_ShapeModel.mat']    );
load( ['model/' options.datasetName '_DataVariation.mat'] );

%% learn cascaded regression %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

imgDir = options.trainingImageDataPath;
ptsDir = options.trainingTruthDataPath;

%% loading data
disp('Loading training data...');
Data = load_all_data2( imgDir, ptsDir, options );

n_cascades = options.n_cascades;
LearnedCascadedModel{n_cascades}.R = [];

rms = zeros(n_cascades,1);

for icascade = 1 : n_cascades
    
    options.current_cascade = icascade;
    
    %% learning single regressors
    if icascade == 1
        
        new_init_shape = [];
        [R,new_init_shape,rms(icascade)] = learn_single_regressor( ...
            ShapeModel, DataVariation, Data, new_init_shape, options );
        
        LearnedCascadedModel{icascade}.R = R;
        
        %% save other parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        LearnedCascadedModel{icascade}.n_cascades = n_cascades;
        LearnedCascadedModel{icascade}.descSize   = options.descSize;
        LearnedCascadedModel{icascade}.descBins   = options.descBins;
        
        
    else
        
        [R, new_init_shape,rms(icascade)] = learn_single_regressor( ...
            ShapeModel, DataVariation, Data, new_init_shape, options );
        
        LearnedCascadedModel{icascade}.R = R;
        
    end
    
end

%save('result/Trained_RMS.mat' , 'rms');

save([options.modelPath options.slash ...
    'LearnedCascadedModel.mat'],'LearnedCascadedModel');
clear;
