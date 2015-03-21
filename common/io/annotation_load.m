function [pts] = annotation_load( fname, data_name )

if strcmp(data_name,'helen') == 1
    pts = helen_annotation_load( fname );
elseif strcmp(data_name,'lfpw') == 1  
    pts = lfpw_annotation_load( fname ); 
elseif strcmp(data_name,'w300') == 1  
    pts = w300_annotation_load( fname ); 
else 
    disp(['dataset name: ' data_name ' is invalid!']);
end

end
