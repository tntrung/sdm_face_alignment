function options = setup( )
%%  @paths    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cwd=cd;
cwd(cwd=='\')='/';

options.workDir    = cwd;
options.slash      = '/'; %% For linux

%% @library paths %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~isdeployed
    
    %training
    addpath([cwd '/source/train/']);
    
    %testing
    addpath([cwd '/source/test/']);
    
    %common
    addpath([cwd '/common/io/']);
    addpath([cwd '/common/align/']);
    addpath([cwd '/common/string/']);
    addpath([cwd '/common/manifold/']);
    addpath([cwd '/common/err/']);
    addpath([cwd '/common/graphic/']);
    addpath([cwd '/common/vec/']);
    addpath([cwd '/common/desc/']);
    addpath([cwd '/common/regression/']);
    addpath([cwd '/common/flip/']);
    addpath([cwd '/common/eval/']);
    addpath([cwd '/common/cropImage/']);
    
    %libs
    addpath([cwd '/lib/liblinear-2.0/matlab']);
    addpath([cwd '/lib/vlfeat/toolbox/']);
    addpath([cwd '/lib/vlfeat/bin/win64/']);
    
end

vl_setup();

%%  @data preparation  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

options.datasetName = 'w300';  %% 'lfpw', 'helen' or 'w300'

options.trainingImageDataPath = './data/lfpw/trainset/';
options.trainingTruthDataPath = './data/lfpw/trainset/';
                                   
options.testingImageDataPath  = './data/lfpw/testset/';
options.testingTruthDataPath  = './data/lfpw/testset/';

options.learningShape     = 0;
options.learningVariation = 0;


options.flipFlag          = 0;   % the flag of flipping

%%  @other folders  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

options.tempPath      = 'temp';
options.modelPath     = 'model';

%% Regression parameter

options.global_regression=2;
options.part_regression=2;
options.local_regression=3;

options.global_index=1:options.global_regression;
options.part_index=[(options.global_regression+1):(options.global_regression+options.part_regression)];
%options.local_index=[(options.global_regression+options.part_regression+1):(options.global_regression+options.part_regression+options.local_regression)];

%%  @training configuration  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

options.canvasSize  = [400 400];
options.scaleFactor = 1;
%options.lambda     = [1 2 3 4 5 6 7] * 100;
options.lambda      = [1 0.8 0.6 0.4 0.1 0.04 0.01] * 0.005;
%%  @feature configuration  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

options.descType  = 'hog'; % raw, hog (124 dims), xx_sift (128 dims)
options.descSize  = [20 20 20 20 20 20 20];
options.descScale = [0.24 0.20 0.16 0.12 0.08 0.04 0.02];
%options.descScale = [0.16 0.16 0.16 0.16 0.16 0.16 0.16];
options.descBins  =  3;
            
%%  @cascade regression %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

options.n_cascades     = 7;         % the number of cascades

options.n_init_randoms = 5;         % the number of initial randoms

options.n_init_randoms_test = 10;    % the number of initial randoms

%%  @evaluation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%options.pts_eval = [1 3 2 4 9 17 11 12 18 10 19 20 21 23 24 25 28];
options.pts_eval = 1:68;
%options.pts_eval = 1:51;
%options.pts_eval = 1:29;

%% enums all landmarks

options.shape={'left_eye','right_eye','nose','mouth','contour'};

%% 300-W dataset (68)
options.inter_ocular_left_eye_idx  = 37:42;
options.inter_ocular_right_eye_idx = 43:48;
options.left_eyebrow_idx=18:22;
options.right_eyebrow_idx=23:27;
options.nose_idx=28:36;
options.mouth_idx=49:68;
options.contour=1:17;
options.shape_idx={options.inter_ocular_left_eye_idx,options.inter_ocular_right_eye_idx,options.left_eyebrow_idx,options.right_eyebrow_idx,options.nose_idx,options.mouth_idx,...
  options.contour  };
%% 300-W dataset (51)
%options.inter_ocular_left_eye_idx  = 20:25;
%options.inter_ocular_right_eye_idx = 26:31;

%options.inter_ocular_left_eye_idx  = 20;
%options.inter_ocular_right_eye_idx = 29;

%% LFPW dataset
%options.inter_ocular_left_eye_idx  = [9 11 13 14 17];
%options.inter_ocular_right_eye_idx = [10 12 15 16 18];

