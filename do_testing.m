function do_testing ( )

%clear all;

%% loading the setup %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
options = setup( );


%% loading training data
load( ['model/' options.datasetName '_ShapeModel.mat']    );
load( ['model/' options.datasetName '_DataVariation.mat'] );
load( [options.modelPath options.slash 'LearnedCascadedModel.mat'] );

%% loading training shapes for randomly initialize shapes.
imgTrainDir = options.trainingImageDataPath;
ptsTrainDir = options.trainingTruthDataPath;

%% loading data
TrainingData = load_data( imgTrainDir, ptsTrainDir, options );

%% test cascaded regression  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

imgDir = options.testingImageDataPath;
ptsDir = options.testingTruthDataPath;

%% loading data
Data  = load_all_data2( imgDir, ptsDir, options );
nData = length(Data);
%nData = 10;

%% evaluating on whole data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

err = zeros(nData,1);

for idata = 1 : nData
    
    disp(['Image: ' num2str(idata)]);
    
    %% information of one image
    img        = Data{idata}.img_gray;
    true_shape = Data{idata}.shape_gt;
    
    %% do face alignment on the image
    aligned_shape = face_alignment( ShapeModel, DataVariation, ...
        LearnedCascadedModel, TrainingData, img, true_shape, options );
    
    %% compute rms errors
    err(idata) = rms_err( aligned_shape, true_shape, options );
    
    if 0
        figure(1); imshow(img); hold on;
        %draw_shape(true_shape(:,1), true_shape(:,2),'r');
        draw_shape(aligned_shape(:,1), aligned_shape(:,2),'g');
        hold off;
        pause;
    end
    
    
end

%% displaying CED
x = [0 : 0.001 :0.5];
cumsum = zeros(length(x),1);

c = 0;

for thres = x
    
    c = c + 1;
    idx = find(err <= thres);
    cumsum(c) = length(idx)/nData;
    
end

figure(2);
plot( x, cumsum, 'LineWidth', 2 , 'MarkerEdgeColor','r');

grid on;

axis([0 0.3 0 1]);

eval_name = ['W300_LFPW_sdm' '.mat'];

EVAL.rms = err;

save(['result/' eval_name],'EVAL');

%% displaying rms errors
disp(['ERR average: ' num2str(mean(err))]);

