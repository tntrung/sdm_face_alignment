function newS = align_shape( TransM , S )

newS = zeros(size(S));

x = S(1:2:end);
y = S(2:2:end);

xy = [x'; y'; ones(1, size(x,1))];
newXY = [TransM ; [0 0 1]]\xy;

newS(1:2:end) = newXY(1,:);
newS(2:2:end) = newXY(2,:);

end

