function [rbbox] = random_init_position( bbox, ...
                                                 DataVariation, nRandInit )

rbbox(1,:) = bbox;    

if nRandInit > 1

center = bbox(1:2) + bbox(3:4)/2;                                            
                                             
mu_trans  = DataVariation.mu_trans;
cov_trans = DataVariation.cov_trans;
mu_scale  = DataVariation.mu_scale;
cov_scale = DataVariation.cov_scale;

%rInit_trans = mvnrnd(mu_trans,cov_trans,nRandInit-1);
rInit_trans = zeros(nRandInit-1,2);

rCenter = repmat(center,nRandInit-1,1) + ...
                      rInit_trans.*repmat([bbox(3) bbox(4)],nRandInit-1,1);

rInit_scale = mvnrnd(mu_scale,cov_scale,nRandInit-1);
%rInit_scale = ones(nRandInit-1,2);

rWidth  = zeros(nRandInit-1,1);
rHeight = zeros(nRandInit-1,1);

for i = 1 : nRandInit - 1
    rWidth(i)  = bbox(3)/rInit_scale(i,1);
    rHeight(i) = bbox(4)/rInit_scale(i,2);
end

rbbox(2:nRandInit,1:2) = rCenter - [rWidth(:,1) rHeight(:,1)]/2;
rbbox(2:nRandInit,3:4) = [rWidth(:,1) rHeight(:,1)];

end

end
