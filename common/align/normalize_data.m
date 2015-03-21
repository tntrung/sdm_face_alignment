function Data = normalize_data ( Data, options )

n = length(Data);

%% noramlizing the first image
shape          = normalize_first_shape( Data(1) , options );
Data(1).shape  = shape;

%% using the first to noramlizing others.
for i = 2 : n
    [shape] = normalize_rest_shape( Data(1), Data(i), options );
    Data(i).shape  = shape;
end

end