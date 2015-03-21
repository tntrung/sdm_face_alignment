function error = calc_shape_error(H, x, dx)


if 0
    numx = size(x, 1);
    
    [x1, val] = quadprog(-H, [], [], [], [], [], -dx*ones(numx, 1), dx*ones(numx, 1), []);
    
    error = val;
else
    error = x'*H*x;
    
end



end
