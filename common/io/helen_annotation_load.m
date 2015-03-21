function [pts] = helen_annotation_load( fpath )

%fpath = ['/home/tranngoctrung/Workspace/These/3dpose/data/input/HELEN/points/' '232194_1.txt'];

pts = [];

if exist(fpath,'file') ~= 0

fp = fopen(fpath,'r');

npts = 194; %predefined
pts  = zeros(npts,2);

count = 0;

while ~feof(fp)
    
    count = count + 1;
    
    line = fgetl(fp);
    
    if count > 1
        terms = strsplit(line,',');
        pts(count-1,1) = str2num(terms{1});
        pts(count-1,2) = str2num(terms{2});
    end
    
end

end

fclose(fp);

end
