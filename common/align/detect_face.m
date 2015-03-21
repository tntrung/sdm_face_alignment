function [boxes] = detect_face( im, options )

% Load a face detector and an image
detector = CascadeClassifier(options.haarFaceCascadeXml);

% Preprocess
if size(im,3) > 1
    gr = rgb2gray(im);
else
    gr = im;
end
gr = equalizeHist(gr);

% Detect
boxes = detector.detect(gr, 'ScaleFactor',  1.3, ...
                            'MinNeighbors', 2, ...
                            'MinSize',      [30, 30]);
% Draw results
% imshow(im);
% for i = 1:numel(boxes)
%     rectangle('Position',  boxes{i}, ...
%               'EdgeColor', 'g');
% end
% 
% end
