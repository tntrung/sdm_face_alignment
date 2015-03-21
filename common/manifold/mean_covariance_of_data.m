%data has nx2
function [mu,cov] = mean_covariance_of_data ( data )

n = size(data,1);
mu = (1/n)*sum(data);

z = data - repmat(mu,n,1);
cov = (1/(n))*z'*z;

end
