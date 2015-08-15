function [R,storage_new_init_shape,rms] = learn_single_regressor...
    ( ShapeModel, DataVariation, Data, new_init_shape, options )

%%%%%%%% properties %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 1. Using randomly ground-truth of image as initial shape for others.
%% 2. Using multi-scale images.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nData = length(Data);

% if flipping data
if options.flipFlag == 1
    nData = nData * 2;
end



%% the fixed parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
shape_dim  = size(ShapeModel.MeanShape,1);
MeanShape2 = vec_2_shape(ShapeModel.MeanShape);
n_points   = shape_dim/2;
n_cascades = options.n_cascades;

current_cascade = options.current_cascade;
n_init_randoms  = options.n_init_randoms;
desc_size       = options.descSize;
desc_bins       = options.descBins;

%% set the current canvas size for multi-scale feature
current_scale = cascade_img_scale(options.scaleFactor,current_cascade,...
    n_cascades);

%设置hog特征维数
%hog_size=round(options.descScale(current_cascade) * current_scale*options.canvasSize(1)/32);
%hog_size=2;

if strcmp(options.descType,'xx_sift') == 1
    desc_dim        = 8 * desc_bins * desc_bins; % xx_sift
elseif strcmp(options.descType,'hog') == 1
    desc_dim        = 2 * 2 * 31; % hog 124
end

%% initial matrices used for storing descriptors and delta shape %%%%%%%%%%
storage_init_shape = zeros(nData*n_init_randoms,shape_dim);
storage_gt_shape   = zeros(nData*n_init_randoms,shape_dim);
storage_new_init_shape = zeros(nData*n_init_randoms,shape_dim);
storage_init_desc  = zeros(nData*n_init_randoms,desc_dim*n_points);
storage_del_shape  = zeros(nData*n_init_randoms,shape_dim);
storage_bbox       = zeros(nData*n_init_randoms,4);
storage_image      = cell(nData*n_init_randoms,1);
R=zeros(desc_dim*n_points,shape_dim);
del_shape=zeros(nData*n_init_randoms,shape_dim);


for idata = 1 : nData
        
    %% the information of i-th image
    %disp(Data(idata).img);
    disp(['Stage: ' num2str(options.current_cascade) ' - Image: ' num2str(idata)]);
    
    if options.flipFlag == 1
        % flipping the image
        flip_iimg = floor((idata+1)/2);
        nrData = nData/2;
    else
        flip_iimg = idata;
        nrData = nData;
    end
    
    img   = Data{flip_iimg}.img_gray;
    shape = Data{flip_iimg}.shape_gt;
    
    %% fipping data
    if options.flipFlag == 1
        
        if mod(idata,2) == 0
            
            if size(img,3) > 1
                img_gray   = fliplr(rgb2gray(uint8(img)));
            else
                img_gray   = fliplr(img);
            end
            
            clear img;
            img = img_gray;
            clear img_gray;
            
            shape = flipshape(shape);
            shape(:,1) = size(img,2)+1 - shape(:, 1);
            
            
            if 0
                figure(1); imshow(img); hold on;
                draw_shape(shape(:,1),...
                    shape(:,2),'y');
                hold off;
                pause;
            end
            
        end
        
    end
    
    %% if the first cascade
    if ( current_cascade == 1 )
        
        %% if detect face using viola opencv
        %boxes = detect_face( img , options );
        
        %% if using ground-truth
        bbox = [];
        
        %% predict the face box
        if isempty(bbox)
            %% if using ground-truth
            bbox = getbbox(shape);
        end
        
        %% randomize n positions for initial shapes
        [rbbox] = random_init_position( ...
            bbox, DataVariation, n_init_randoms,options );
        
        %% randomize which shape is used for initial position
        rIdx = randi([1,nrData],n_init_randoms);
        
        %% iterations of n initial points
        for ir = 1 : n_init_randoms
            
            %% get random positions and inital shape indexs
            idx    = rIdx(ir);
            init_shape = Data{idx}.shape_gt; %% get randomly shape from others
            cbbox  = rbbox(ir,:);
            
            %init_shape = resetshape(cbbox, init_shape);
            init_shape = resetshape(cbbox, MeanShape2);
 
            if 0
                figure(1); imshow(img); hold on;
                draw_shape(init_shape(:,1),...
                    init_shape(:,2),'y');
                hold off;
                pause;
            end           
            
            %% scale coarse to fine %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            cropIm_scale = imresize(img,current_scale);
            init_shape = init_shape * current_scale;
            true_shape    = shape      * current_scale;
            
            if 0
                figure(1); imshow(cropIm_scale); hold on;
                draw_shape(init_shape(:,1), init_shape(:,2),'g');
                draw_shape(true_shape(:,1), true_shape(:,2),'r');
                hold off;
                pause;
            end
            
            storage_bbox((idata-1)*n_init_randoms+ir,:) = ...
                getbbox(init_shape);
            
            %% compute the descriptors and delta_shape %%%%%%%%%%%%%%%%%%%%
            
            % storing the initial shape
            storage_init_shape((idata-1)*n_init_randoms+ir,:) = ...
                shape_2_vec(init_shape);
            
            % storing the the descriptors
            tmp = local_descriptors( cropIm_scale, ...
                init_shape,...
                desc_size, desc_bins, options );
            
            storage_init_desc((idata-1)*n_init_randoms+ir,:) = tmp(:);
            
            % storing delta shape
            tmp_del = init_shape - true_shape;
            shape_residual = bsxfun(@rdivide, tmp_del, ...
                storage_bbox((idata-1)*n_init_randoms+ir,3:4));
            
            storage_del_shape((idata-1)*n_init_randoms+ir,:) = ...
                shape_2_vec(shape_residual);
            
            storage_gt_shape((idata-1)*n_init_randoms+ir,:) = ...
                shape_2_vec(shape);
            storage_image{(idata-1)*n_init_randoms+ir}=cropIm_scale;%补充项          
        end
        
    else
        
        % for higher cascaded levels
        for ir = 1 : n_init_randoms
            
            init_shape = vec_2_shape(new_init_shape((idata-1)*n_init_randoms+ir,:)');
            
            %% scale coarse to fine %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %% scale coarse to fine %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            cropIm_scale = imresize(img,current_scale);
            init_shape = init_shape * current_scale;
            true_shape = shape      * current_scale;
            
            %% compute the descriptors and delta_shape %%%%%%%%%%%%%%%%%%%%
            
            if 0
                figure(1); imshow(cropIm_scale); hold on;
                draw_shape(init_shape(:,1), init_shape(:,2),'g');
                draw_shape(true_shape(:,1), true_shape(:,2),'r');
                hold off;
                pause;
            end            
            
            storage_bbox((idata-1)*n_init_randoms+ir,:) = ...
                getbbox(init_shape);
            
            %% compute the descriptors and delta_shape %%%%%%%%%%%%%%%%%%%%
            
            % storing the initial shape
            storage_init_shape((idata-1)*n_init_randoms+ir,:) = ...
                shape_2_vec(init_shape);
            
            % storing the the descriptors
            tmp = local_descriptors( cropIm_scale, ...
                init_shape,...
                desc_size, desc_bins, options );
            storage_init_desc((idata-1)*n_init_randoms+ir,:) = tmp(:);
            
            % storing delta shape
            tmp_del = init_shape - true_shape;
            shape_residual = bsxfun(@rdivide, tmp_del, ...
                storage_bbox((idata-1)*n_init_randoms+ir,3:4));
            
            storage_del_shape((idata-1)*n_init_randoms+ir,:) = ...
                shape_2_vec(shape_residual);
            
            storage_gt_shape((idata-1)*n_init_randoms+ir,:) = ...
                shape_2_vec(shape);
            
           storage_image{(idata-1)*n_init_randoms+ir}=cropIm_scale;%补充项
        end
        
    end
    
    clear img;
    clear cropIm_scale;
    clear shape;
    
end

%% solving multivariate linear regression %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ismember(current_cascade,options.global_index)
      disp('solving linear regression problem...');
       R = linreg( storage_init_desc, storage_del_shape, ...
           options.lambda(current_cascade) );
%% updading the new shape %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      disp('updadting the shape...');
     del_shape = regress( storage_init_desc, R );
elseif ismember(current_cascade,options.part_index)
    shape_desc_idx=cell(1,7);
    shape_del_idx=cell(1,7);
    R_idx=cell(1,7);
    for jdesc_idx=1:7
        shape_desc_idx{jdesc_idx}=((options.shape_idx{jdesc_idx}(1)-1)*desc_dim+1):options.shape_idx{jdesc_idx}(end)*desc_dim;
        shape_del_idx{jdesc_idx}=((options.shape_idx{jdesc_idx}(1)-1)*2+1):options.shape_idx{jdesc_idx}(end)*2;
        R_idx{jdesc_idx}=struct('x_idx',((options.shape_idx{jdesc_idx}(1)-1)*desc_dim+1):options.shape_idx{jdesc_idx}(end)*desc_dim,...
            'y_idx',((options.shape_idx{jdesc_idx}(1)-1)*2+1):options.shape_idx{jdesc_idx}(end)*2);
    end
    shape_desc_idx2=cell(1,5);
      shape_desc_idx2{1}=union(shape_desc_idx{1},shape_desc_idx{3});
      shape_desc_idx2{2}=union(shape_desc_idx{2},shape_desc_idx{4});
      shape_desc_idx2{3}=shape_desc_idx{5};
      shape_desc_idx2{4}=shape_desc_idx{6};
      shape_desc_idx2{5}=shape_desc_idx{7};
      
    shape_del_idx2=cell(1,5);
      shape_del_idx2{1}=union(shape_del_idx{1},shape_del_idx{3});
      shape_del_idx2{2}=union(shape_del_idx{2},shape_del_idx{4});
      shape_del_idx2{3}=shape_del_idx{5};
      shape_del_idx2{4}=shape_del_idx{6};
      shape_del_idx2{5}=shape_del_idx{7};

   R_idx2=cell(1,5);
      R_idx2{1}=struct('x_idx',union(R_idx{1}.x_idx,R_idx{3}.x_idx),'y_idx',union(R_idx{1}.y_idx,R_idx{3}.y_idx));
      R_idx2{2}=struct('x_idx',union(R_idx{2}.x_idx,R_idx{4}.x_idx),'y_idx',union(R_idx{2}.y_idx,R_idx{4}.y_idx));
      R_idx2{3}= R_idx{5};
      R_idx2{4}= R_idx{6};
      R_idx2{5}= R_idx{7};
       clear  shape_desc_idx;
       clear  shape_del_idx;
       clear  R_idx;
      
      disp('solving linear regression problem...');
     for iregression=1:5%将特征点分为5个区域，分别回归
     % iregression=5;
          R2= linreg( storage_init_desc(:,shape_desc_idx2{iregression}), storage_del_shape(:,shape_del_idx2{iregression}), ...
           options.lambda(current_cascade) );
       R(R_idx2{iregression}.x_idx,R_idx2{iregression}.y_idx)=R2;
       
      fprintf('updadting the  %s\n',options.shape{iregression});
      del_shape(:,shape_del_idx2{iregression}) = regress( storage_init_desc(:,shape_desc_idx2{iregression}), R2); 
      clear R2;
     end
      clear  shape_desc_idx2;
     clear  shape_del_idx2;  
     clear  R_idx2;
     
else
   
      disp('solving linear regression problem...');
      for ipoint=1:n_points%对每个顶点分别回归
      
          R2= linreg( storage_init_desc(:,((ipoint-1)*desc_dim+1):(ipoint*desc_dim)), storage_del_shape(:,((ipoint-1)*2+1):(ipoint*2)), ...
           options.lambda(current_cascade) );
       R(((ipoint-1)*desc_dim+1):(ipoint*desc_dim),((ipoint-1)*2+1):(ipoint*2))=R2;
      del_shape(:,((ipoint-1)*2+1):(ipoint*2)) = regress( storage_init_desc(:,((ipoint-1)*desc_dim+1):(ipoint*desc_dim)), R2); 
      clear R2;
      end
     
end
    

nsamples = size(storage_init_desc,1);

for isample = 1 : nsamples
    
    origin_del = bsxfun(@times, vec_2_shape(del_shape(isample,:)'), ...
        storage_bbox(isample,3:4));
    shape      = storage_init_shape(isample,:) - shape_2_vec(origin_del)';
    shape      = shape / current_scale;
    storage_new_init_shape(isample,:) = shape;
 
%   if isample==2 %每一次测试时应该红色的和黑的比较接近，这样我们计算的R才正确。
%         init_shape= storage_init_shape(isample,:);
%         init_shape=init_shape';
%         init_shape=[init_shape(1:2:end),init_shape(2:2:end)];%init_shape=vec_2_shape(init_shape);
%         true_shape=storage_gt_shape(isample,:);
%         true_shape=true_shape';
%          true_shape=[true_shape(1:2:end),true_shape(2:2:end)];%true_shape=vec_2_shape(true_shape);
%        shape2=storage_new_init_shape(isample,:);
%        shape2=shape2';
%          shape2=[shape2(1:2:end),shape2(2:2:end)];%shape=vec_2_shape(shape2);
%          cropIm_scale=storage_image{isample};
%                 figure(1); imshow(cropIm_scale); hold on;
%                 draw_shape(init_shape(:,1), init_shape(:,2),'g');
%                 draw_shape(true_shape(:,1), true_shape(:,2),'r');
%                  draw_shape(shape2(:,1), shape2(:,2),'k');
%                 hold off;
%            %pause;
%      end  
 
end

%% compute errors

err = zeros(nsamples,1);

for i = 1:nsamples
    
    pr_shape = storage_new_init_shape(i,:);
    gt_shape = storage_gt_shape(i,:);
    
    err(i) = rms_err( vec_2_shape(pr_shape'), vec_2_shape(gt_shape'), options);
    
end

rms = 100*mean(err);

disp(['ERR average: ' num2str(100*mean(err))]);

clear storage_init_shape;
clear storage_gt_shape;
clear storage_init_desc;
clear storage_del_shape;
clear storage_transM;
clear storage_image;
