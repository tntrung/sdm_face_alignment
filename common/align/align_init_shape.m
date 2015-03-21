function [Si] = align_init_shape( Shape , x, y, width, height )

% Make initial CLM guess from a bounding rectangle.
% 
% Input:
% 	image: input image.
%	x, y: center position.
%   theta: rotation.
%   width, height: size of bounding rectangle.
% Output:
%   Si.XY: column vector, [x1 y1 x2 y2 .... ];

NumPts = size(Shape,1)/2;

MeanX = Shape(1:2:end);
MeanY = Shape(2:2:end);
MeanX = MeanX - mean(MeanX);
MeanY = MeanY - mean(MeanY);

ShapeW = max(MeanX) - min(MeanX);
ShapeH = max(MeanY) - min(MeanY);

%%%%%%%%%%%%%%%%%%%%%%%%%%
% calculate scale factor
%%%%%%%%%%%%%%%%%%%%%%%%%%
scfW = width/ShapeW;
scfH = height/ShapeH;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate template x,y.
% This is not intended to be accurate,
% just barely enough for initial guess.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tXY = [scfW*MeanX'; scfH*MeanY'; 
                    ones(1, size(MeanY, 1))] + repmat([x y 1]', 1, NumPts);


%%%%%%%%%%%%%%%%%%%%%%%
% assemble initals
%%%%%%%%%%%%%%%%%%%%%%%

Si = struct;
Si.XY = zeros(NumPts*2, 1);
Si.XY(1:2:end) = tXY(1, :)';
Si.XY(2:2:end) = tXY(2, :)';

end
