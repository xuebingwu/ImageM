function [num_dots_cell,location_cell]=counting_dots(dirname,file_index,channel_name,BW,RECT,N,sigma)

% [num_dots_cell,location_cell]=process_file_counting(dirname,file_index,xi,yi,BW)
% 20/11/09 Shalev.
% The root function for FISH quantification
% The function first calls process_file_cropping on the dapi image, and
% then applies the cropping + counting to all channels
% If more than two input arguments are given, the function does not allow
% cropping but rather uses the input variables

n = 0;
col = 'rgb';
for j=1:length(channel_name),
    filename = [channel_name{j} file_index '.tif'];
    title(['parsing ' filename],'FontSize',18,'Color','r');drawnow;
    ims=parse_stack([dirname filename]);

    ims2=crop_stack_poly(ims,RECT,BW);
    
    % Call the file that returns the number of dots for different thresholds
    [thresholdfn,thresholds,ims_filtered]=calculate_file_threshold_function(ims2,BW,N,sigma);
    ims=ims2;ims2=ims_filtered;
    % Finally let the user choose the appropriate threshold for this file
    [num_dots,locations,threshold]=process_file_threshold_selection(thresholds,thresholdfn,ims,ims2,BW);
    n = n+1;
    num_dots_cell{n}=num_dots;
    location_cell{n}=locations;
    
    % plot dots onto the image
    plot(locations(:,1),locations(:,2),'o','MarkerSize',4,'Color',col(j));  
end




