function write_w300_shape( shape,write_dir )
%write shape to dir
%格式如下：
% version: 1
% n_points:  68
% {
%    1.2639  146.8353
%     1.0000  162.7446
%    .............
%    66.1967  204.6640
%    76.5473  204.4326
%    66.1967  204.6640
%    62.5408  205.1070
%    57.5440  205.2591
% }
fid=fopen(write_dir,'wt');
fprintf(fid,'%s\n','version: 1');
fprintf(fid,'%s\n','n_points: 68');
fprintf(fid,'%s\n','{');
for idata=1:size(shape,1)
        fprintf(fid,'\t%.4f\t%.4f\n',shape(idata,1),shape(idata,2));    
end
fprintf(fid,'%s\n','}');

fclose(fid);

end

