function [xy] = vec_2_shape( shape )

xy = zeros(size(shape,1)/2,2);

xy(:,1) = shape(1:2:end);
xy(:,2) = shape(2:2:end);
