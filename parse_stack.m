function ims=parse_stack(filename,first,last)

% ims=parse_stack(filename)
% 12/11/09
% Parses metamorph stack file with S 2D images of size n*m and outputs a
% n*m*S double 3D array

if nargin < 2
    stack = tiffread2(filename);
else
    stack = tiffread2(filename,first,last); 
end

[n,m]=size(stack(1).data);
ims=zeros(n,m,length(stack));

for i=1:length(stack),
    %ims(:,:,i)=double(stack(i).data);
    ims(:,:,i)=stack(i).data;
end