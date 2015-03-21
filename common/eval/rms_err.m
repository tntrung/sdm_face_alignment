function rms = rms_err (aligned_shape, true_shape, options )

pts_eval = options.pts_eval;
n_pts    = size(pts_eval,2);

X_align = aligned_shape(pts_eval,:);
X_true  = true_shape(pts_eval,:);

sum = 0;

%% compute rms
for ipts = 1 : n_pts
    sum = sum + norm( X_align(ipts,:) - X_true(ipts,:) );
end

rms = sum/n_pts;

%% compute eye centroids 300-W
centroid_left  = mean(X_true(options.inter_ocular_left_eye_idx,:));
centroid_right = mean(X_true(options.inter_ocular_right_eye_idx,:));

%% compute eye centroids LFPW
%centroid_left  = true_shape(options.inter_ocular_left_eye_idx,:);
%centroid_right = true_shape(options.inter_ocular_right_eye_idx,:);

inter_ocular_distance = norm(centroid_left - centroid_right);

rms = rms/inter_ocular_distance;

disp(['rms = ' num2str(rms)]);

end
