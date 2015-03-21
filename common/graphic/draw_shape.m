function draw_shape(x, y, color)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Draw face given x, y
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% inverse y for better visual

bbox = getbbox([x y]);

radius = bbox(4) / 20;

if 1
    %hold on;
    
    n = size(x,1);
    
    for i = 1 : n
        
        r = x(i) - radius/2;
        c = y(i) - radius/2;
        
        rectangle('Position',[r,c,radius,radius],'Curvature',[1,1],...
            'FaceColor',color);
        
    end
    
    %plot(x, y, color);
    %plot(x, y, [color '.']);
    
    %hold off;
end

