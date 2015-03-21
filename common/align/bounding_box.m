function [cropmin,cropmax,offset,minshape,marginW,marginH] = ...
    bounding_box ( shape )

minshape = min(shape);
maxshape = max(shape);

%% calculating bounding box %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
width   = maxshape(1) - minshape(1);
height  = maxshape(2) - minshape(2);

marginW = width/2;
marginH = height/2;

cropmin = round(minshape - [marginW marginH]);
cropmax = round(maxshape + [marginW marginH]);

offset = [0 0];

if(cropmin(1)<=0)
    offset(1)  = -cropmin(1);
    cropmin(1) = 1;
end

if(cropmin(2)<=0)
    offset(2)  = -cropmin(2);
    cropmin(2) = 1;
end

end