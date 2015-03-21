function aligned_shape = cascaded_regress (  ShapeModel, ...
    LearnedCascadedModel, img, init_shape, options  )


%% parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n_cascades = LearnedCascadedModel{1}.n_cascades;
desc_size  = LearnedCascadedModel{1}.descSize;
desc_bins  = LearnedCascadedModel{1}.descBins;
factor     = options.scaleFactor;


%% iterations of cascades %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for ic = 1 : n_cascades
    
    current_scale = cascade_img_scale(factor, ic, n_cascades);
    
    options.current_cascade = ic;
    
    cropIm_scale = imresize(img,current_scale);
    init_shape   = init_shape * current_scale;
    
    if 1
        figure(1); imshow(cropIm_scale); hold on;
        draw_shape(init_shape(:,1), init_shape(:,2),'g');
%        draw_shape(true_shape(:,1), true_shape(:,2),'r');
        hold off;
        pause;
    end
    
    bbox = getbbox(init_shape);
    
    % extract local descriptors
    desc = local_descriptors(cropIm_scale, ...
        init_shape, desc_size, desc_bins, options);
    
    % regressing
    del_shape = regress( desc(:)', LearnedCascadedModel{ic}.R );
    
    origin_del = bsxfun(@times, vec_2_shape(del_shape'), bbox(3:4));
    
    % estimate the new shape
    tmp_shape = init_shape - origin_del;
    
    tmp_shape = tmp_shape / current_scale;
    
    init_shape    = tmp_shape;
    
    aligned_shape = shape_2_vec(tmp_shape);
    
end


if 0
    figure(1); imshow(img); hold on;
    draw_shape(aligned_shape(1:2:end),...
        aligned_shape(2:2:end),'y');
    hold off;
    pause;
end


end

