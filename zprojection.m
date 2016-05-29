function ims2 = zprojection(ims,method)
if strcmp(method,'max')
    ims2=max(ims,[],3);
elseif strcmp(method,'std')
    ims2=std(ims,0,3);
elseif strcmp(method,'mean')
    ims2=mean(ims,3);
else
    ims2=std(ims,0,3)./mean(ims,3);
end
ims2=ims2/max(ims2(:));
    