function ims2=gui_crop_stack_poly(ims,RECT,BW)

% ims2=crop_stack_poly(ims,RECT,BW)
% crops all stack images with RECT rectangle and zeros anything out of the
% polygon pixels that are 1 in BW.

s=size(ims);
if size(BW,1)==s(1) & size(BW,2)==s(2), % need to crop the mask, hasn't been done previously
    BW2=imcrop(BW,RECT);
else
    BW2=BW;
end
% Also multiply by a smoothed version of the polygon BW image
H=fspecial('average',5);
BWsmooth=imfilter(BW,H);

for j=1:size(ims,3),
    Y1=ims(:,:,j);
    YY=imcrop(Y1,RECT);
%     YY(find(BW2==0))=min(min(YY));
%    YY=YY.*BWsmooth;
%    YY(YY==0)=mean(mean(YY(YY~=0)));
    ims2(:,:,j)=YY;
end
% 
% % Equalize stack histograms
% %ims3=equalize_stack(ims2,threshold);
% %ims3=enhance_stack(ims2);

% Now zero the masked background
for j=1:size(ims2,3),
    YY=ims2(:,:,j);
    YY=YY.*BWsmooth;
    YY(YY==0)=min(min(YY(YY~=0)));
    ims2(:,:,j)=YY;
end