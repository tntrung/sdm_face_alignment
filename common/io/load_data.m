function [data] = load_data( imgDir, ptsDir , options )

slash = options.slash;

plist = dir([imgDir slash 'image*.*g']);
nlist = length(plist);
%nlist = 10;

data(nlist).shape   = [];
data(nlist).img     = '';

for ilist = 1 : nlist
    
    img_name = plist(ilist).name;
    pts_name = [img_name(1:end-3) 'pts'];
    
    pts_path = [ptsDir slash pts_name];
    img_path = [imgDir slash img_name];
    
    data(ilist).shape  = annotation_load( pts_path , options.datasetName );
    data(ilist).img    = img_path;
    
    if 0
        img = imread(img_path);
        figure(1); imshow(img); hold on;
        draw_shape(data(ilist).shape(:,1),...
            data(ilist).shape(:,2),'y');
        hold off;
        pause;
    end
        
end

end
