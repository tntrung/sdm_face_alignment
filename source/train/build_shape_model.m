function shapeModel = build_shape_model( Data )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% shapeModel= build_shape_model( Data )
% Build shape model using Training data.
%
% Inputs:
%   Data: input training data.
%
% Outputs:
%   shapeModel: shape model.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Number of datasets
s=length(Data);

% Number of landmarks
nl = length(Data(1).shape);

% Construct a matrix with all contour point data of the training data set.
x=zeros(nl*2,s);
for i=1:length(Data)
    x(1:2:end, i) = Data(i).shape(:,1);
    x(2:2:end, i) = Data(i).shape(:,2);
    %x(:,i)=[TrainingData(i).centerx TrainingData(i).centery]';
end

[Evalues, Evectors, MeanShape]=PCA(x);

% Keep only 99% of all eigen vectors, (remove contour noise)
i=find(cumsum(Evalues)<sum(Evalues)*0.99,1,'last')+1;

%i=11;

Evectors=Evectors(:,1:i);
Evalues=Evalues(1:i);

debug = 0;

if debug
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Calculate shape error, reserved for future extension.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    x=zeros(nl*2,1);
    error = zeros(s, 1);
    
    i_ee = (eye(nl*2)-Evectors*Evectors');
    H = 2*i_ee'*i_ee;
    
    bs = zeros(length(Data), size(Evectors, 2));
    
    for i=1:length(Data)
        x(1:2:end) = Data(i).shape(:,1);
        x(2:2:end) = Data(i).shape(:,2);
        x = x-MeanShape;
        dx = max(abs(x));
        error(i) = calc_shape_error(H, x, dx);
        bs(i, :) = Evectors'*x./sqrt(Evalues);
    end
    
end

% Store the Eigen Vectors and Eigen Values
shapeModel.NumEvalues = length(Evalues);
shapeModel.NumPts = nl;

shapeModel.Evectors =Evectors;
shapeModel.Evalues  =Evalues;
shapeModel.MeanShape=MeanShape;

% Show some eigenvector variations
if debug
    figure;
    for i=1:10
        xtest = shapeModel.MeanShape + ...
            shapeModel.Evectors(:,i)*sqrt(shapeModel.Evalues(i))*3;
        subplot(2,5,i), hold on;
        draw_shape(xtest(1:2:end),xtest(2:2:end),'r');
        draw_shape(shapeModel.MeanShape(1:2:end),...
            shapeModel.MeanShape(2:2:end),'b');
    end
end

