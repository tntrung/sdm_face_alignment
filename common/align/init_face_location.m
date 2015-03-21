function [initX,initY,width,height] = init_face_location( rect )

%initialize mean face
initX = rect(1) + rect(3)/2;
initY = rect(2) + rect(4)/2.5;

width  = rect(3)/2;
height = rect(4)/2;

end