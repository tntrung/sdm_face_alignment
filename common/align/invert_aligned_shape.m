function invShape = invert_aligned_shape( M, shape )

TransM   = [M ; [0 0 1]];
temp1    = [shape(1:2:end) ; shape(2:2:end) ; ones(1,size(shape,2)/2)];
temp2    = (TransM*temp1)';
invShape = shape_2_vec(temp2(:,1:2));

end
