function [Data] = load_all_data2 ( dbpath_img, dbpath_pts, options )

%% output format
%{
DATA.
- width_orig: the width of the original image.
- height_orig: the height of the original image.
- img_gray: the crop image.
- height: the height of crop image.
- wdith: the width of crop image.
- shape_gt: ground-truth landmark.
- bbox_gt: bounding box of ground-truth.
- bbox_facedet: face detection region
%}

slash = options.slash;
dbname = options.datasetName;

imlist = dir([dbpath_img slash '*.*g']);
nimgs  = length(imlist);
%nimgs  = 10;

%% face detection
% Create a cascade detector object.
%faceDetector = vision.CascadeObjectDetector();

isdetected     = zeros(length(nimgs), 1);

Data = cell(nimgs, 1);

for iimgs = 1 : nimgs
    
    %% load images
    img = im2uint8(imread([dbpath_img slash imlist(iimgs).name]));
    Data{iimgs}.width_orig  = size(img,2);
    Data{iimgs}.height_orig = size(img,1);
    
    %% load shape
    Data{iimgs}.shape_gt = double(annotation_load(...
        [dbpath_pts slash imlist(iimgs).name(1:end-3) 'pts'] , dbname));
    
    if 0
        figure(1); imshow(img); hold on;
        draw_shape(Data{iimgs}.shape_gt(:,1),...
            Data{iimgs}.shape_gt(:,2),'y');
        hold off;
        pause;
    end    
    
    
    %% get bounding box
    Data{iimgs}.bbox_gt = getbbox(Data{iimgs}.shape_gt);
    
    %% enlarge region of face
    region     = enlargingbbox(Data{iimgs}.bbox_gt, 2.0);
    region(2)  = double(max(region(2), 1));
    region(1)  = double(max(region(1), 1));
    
    bottom_y   = double(min(region(2) + region(4) - 1, ...
        Data{iimgs}.height_orig));
    right_x    = double(min(region(1) + region(3) - 1, ...
        Data{iimgs}.width_orig));
    
    img_region = img(region(2):bottom_y, region(1):right_x, :);
    
    %% recalculate the location of groundtruth shape and bounding box
    Data{iimgs}.shape_gt = bsxfun(@minus, Data{iimgs}.shape_gt,...
        double([region(1) region(2)]));
    
    Data{iimgs}.bbox_gt = getbbox(Data{iimgs}.shape_gt);
    
    Data{iimgs}.isdet = 0;
    
    % detect the face
    %bbox = step(faceDetector, img_region);
    bbox = [];
    
    if isempty(bbox)
        % if face detection is failed
        isdetected(iimgs) = 0;
        Data{iimgs}.bbox_facedet = getbbox(Data{iimgs}.shape_gt);
        
    else
        int_ratios = zeros(1, size(bbox, 1));
        for b = 1:size(bbox, 1)
            area = rectint(Data{iimgs}.bbox_gt, bbox(b, :));
            int_ratios(b) = (area)/(bbox(b, 3)*bbox(b, 4) + ...
                Data{iimgs}.bbox_gt(3)*Data{iimgs}.bbox_gt(4) - area);
        end
        [max_ratio, max_ind] = max(int_ratios);
        
        if max_ratio < 0.5  % detection fail
            isdetected(iimgs) = 0;
        else
            Data{iimgs}.bbox_facedet = bbox(max_ind, 1:4);
            isdetected(iimgs) = 1;
        end
        
    end
    
    %if size(img_region, 3) == 1
        Data{iimgs}.img_gray = img_region;
    %else
        % hsv = rgb2hsv(img_region);
    %    Data{iimgs}.img_gray = rgb2gray(img_region);
    %end
    
    Data{iimgs}.width    = size(img_region, 2);
    Data{iimgs}.height   = size(img_region, 1);
    
    if 0
        figure(1); imshow(Data{iimgs}.img_gray); hold on;
        draw_shape(Data{iimgs}.shape_gt(:,1),...
            Data{iimgs}.shape_gt(:,2),'y');
        hold off;
        pause;
    end
    
    
    %% normalized the image to the mean-shape
    sr = options.canvasSize(1)/Data{iimgs}.width;
    sc = options.canvasSize(2)/Data{iimgs}.height;
    
    Data{iimgs}.img_gray = imresize(Data{iimgs}.img_gray,options.canvasSize);
    
    Data{iimgs}.width    = options.canvasSize(1);
    Data{iimgs}.height   = options.canvasSize(2);
    
    Data{iimgs}.shape_gt = bsxfun(@times, Data{iimgs}.shape_gt, [sr sc]); 
    
    Data{iimgs}.bbox_facedet(1:2) = bsxfun(@times, Data{iimgs}.bbox_facedet(1:2), [sr sc]);
    Data{iimgs}.bbox_facedet(3:4) = bsxfun(@times, Data{iimgs}.bbox_facedet(3:4), [sr sc]);
    
    %disp(size(Data{iimgs}.img_gray));
    
    if 0
        figure(1); imshow(Data{iimgs}.img_gray); hold on;
        draw_shape(Data{iimgs}.shape_gt(:,1),...
            Data{iimgs}.shape_gt(:,2),'r');
        hold off;
        pause;
    end       
    
end


end


function region = enlargingbbox(bbox, scale)

region(1) = floor(bbox(1) - (scale - 1)/2*bbox(3));
region(2) = floor(bbox(2) - (scale - 1)/2*bbox(4));

region(3) = floor(scale*bbox(3));
region(4) = floor(scale*bbox(4));

end

