function [shape] = w300_annotation_load( fpath )

if exist(fpath,'file') ~= 0

fp = fopen(fpath,'r');

idx  = 1:68;

npts = 68; %pre-defined

pts  = zeros(npts,2);

%forget 3 first lines
line = fgetl(fp);
line = fgetl(fp);
line = fgetl(fp);

for i = 1 : npts
    
    line = fgetl(fp);
    terms = strsplit(line);
    pts(i,1) = str2double(terms{1});
    pts(i,2) = str2double(terms{2});
    
end

end

shape = pts(idx,:);

fclose(fp);

end
