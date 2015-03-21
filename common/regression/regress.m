function Y = regress( X , R )

%% if using ridge regression
Y = X * R;

%Y = [ones(size(X,1),1) X] * R;

end
