function [shape] = shape_2_vec( xy )

shape = zeros(size(xy,1)*2,1);

shape(1:2:end) = xy(:,1);
shape(2:2:end) = xy(:,2);
