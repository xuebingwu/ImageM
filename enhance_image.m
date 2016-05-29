function ims2 = enhance_image(ims,method)
method
if strcmp(method,'histeq')
    ims2=histeq(ims);
elseif strcmp(method,'adapthisteq')
    ims2=adapthisteq(ims);
else strcmp(method,'imadjust')
    ims2=imadjust(ims);
end
    