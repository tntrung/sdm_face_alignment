function [rect] = get_correct_region ( boxes, xy , type )

minx = min(xy(:,1));
miny = min(xy(:,2));
maxx = max(xy(:,1));
maxy = max(xy(:,2));

w = maxx - minx;
h = maxy - miny;
wh = w*h;

center = [minx + w/2 miny + h/2];
rect   = [];

max_face = 0;

if ~isempty(boxes)
    
    n = length( boxes );
    
    for i = 1 : n
        box = boxes{i};
        boxcenter(1) = box(1) + box(3)/2;
        boxcenter(2) = box(2) + box(4)/2;
        b1 = abs(boxcenter(1) - center(1)) < w;
        b2 = abs(boxcenter(2) - center(2)) < h;
        area = box(3)*box(4);
        if b1 && b2 && max_face < area
            rect = box;
            max_face = area;
        end
    end
    
end

if type == 1
    
    if ~isempty(rect)
        
        center_face = rect(1:2) + rect(3:4)/2;
        rect(1:2) = center_face - rect(3:4)*2/3;
        rect(3:4) = rect(3:4) * 4/3;
        
    else
        
        disp('No face detection, so using instead ground-truth.');
        
        [cropmin,cropmax,offset] = bounding_box( xy );
        rect = [cropmin cropmax - cropmin];
        
    end
    
end

end
