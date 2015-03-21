function [pts,visi] = lfpw_annotation_load( fpath )

%fpath = ['/home/tranngoctrung/Workspace/These/3dpose/data/input/HELEN/points/' '232194_1.txt'];

pts = [];

if exist(fpath,'file') ~= 0

fp = fopen(fpath,'r');

npts = 29; %predefined
pts  = zeros(npts,2);
visi = zeros(npts,1);

count = 0;
idx   = 0;

while ~feof(fp)
    
    count = count + 1;
    
    line = fgetl(fp);
    
    if count > 1 && count ~= 30 && count ~= 31 && count ~= 32 ...
       && count ~= 33 && count ~= 34 && count ~= 35
        
        terms = strsplit(line,' ');
        
        idx = idx + 1;
        
        pts(idx,1)  = str2double(terms{1});
        pts(idx,2)  = str2double(terms{2});
        visi(idx,1) = str2double(terms{3});
        
    end
    
end

fclose(fp);

end

end
