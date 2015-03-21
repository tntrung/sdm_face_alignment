function wimg = quad2Box(img, dst, M, f_type)
% QUADTOBOX - Warp contents of a quadrilateral to a rectangle
%   W = QUADTOBOX(IMG, DST, M, F_TYPE)
%
%   Destination corners, DST = [x1, x2, x3, x4; y1, y2, y3, y4];
%   These are the (assumed rectangular) corner points of the template
%   image and must be integers.
%
%   The affine matrix, M transforms DST into the image IMG 
%   [u v 1] (image) = M * [x y 1] (DST - template);
%
%   Matlab style indices, i.e. start from 1.

% Adapted from Iain Matthews, Simon Baker, Carnegie Mellon University, Pittsburgh
% Lucas-Kanade, 20 years on. 

if nargin<4 f_type = 'bilinear'; end
if nargin<3 error('Invalid args'); end

% Dimensions of destination image - integers, assume rectangle
minv = min(dst');
maxv = max(dst');

% Get all points in destination to sample
[xg yg] = meshgrid(minv(1):maxv(1), minv(2):maxv(2));
xy = [reshape(xg, prod(size(xg)), 1)'; reshape(yg, prod(size(yg)), 1)'];
xy = [xy; ones(1,size(xy,2))];

% Transform into source
uv = M * xy;

% Remove homogeneous
uv = uv(1:2,:)';

if(0)
    figure(1);
    ww = round(uv);
    plot(ww(:, 1), ww(:, 2), '.');
    pause;
end

if 0
    
    minvt = min(uv);
    maxvt = max(uv);
    imshow( img ); hold on;
    rect = [minvt(1) minvt(2) maxvt(1) - minvt(1) maxvt(2) - minvt(2)];
    rectangle('Position',  rect, 'EdgeColor', 'g');
    hold off;
    
end

% Sample
xi = reshape(uv(:,1),round(maxv(2)-minv(2)+1),round(maxv(1)-minv(1)+1));
yi = reshape(uv(:,2),round(maxv(2)-minv(2)+1),round(maxv(1)-minv(1)+1));
wimg = interp2(img, xi, yi, f_type);

% Check for NaN background pixels - replace them with a background of 0
idx = find(isnan(wimg));
if ~isempty(idx)
	wimg(idx) = 0;
end
