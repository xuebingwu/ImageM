
% This function will count the number of mRNAs for npoints thresholds
% from 0 up to the maximum intensity of the input image.

function [nout,thresholds,spot_xyz] = BW_multithreshstack(handles,ims,BW,npoints)

% Note ims is already the log filtered image


USE_UNIFORM=1; % Use uniformly spaced thresholds (Arjun's method)

if ~isempty(BW)
    USE_ERODE_MASK=1;
    ERODE_MASK_SIZE=20;
    
    % Normalize image
    ims = ims/max(ims(:));
    last_stack=size(ims,3);
    if USE_ERODE_MASK,
        BW2=imerode(BW,strel('square',20));
        for kk=1:last_stack,
            ims(:,:,kk)=ims(:,:,kk).*BW2;
        end
    end
    for k=1:last_stack,
        temp=ims(:,:,k);
        temp(temp==0)=min(min(temp(temp~=0)));
        ims(:,:,k)=temp;
    end
end
% Compute thresholds according to equal histogram sampling
[p,x]=hist(ims(:),10000);
p=p/sum(p);
C=cumsum(p);
vec=linspace(C(1),C(end),npoints);

% Over-riding this with Arjun's code
if USE_UNIFORM,
    thresholds=(1:npoints)/npoints;
else
    thresholds=zeros(1,npoints);
    for i=1:npoints,
        if isempty(find(C>=vec(i))),
            thresholds(i)=x(1);
        else
            thresholds(i)=x(min(find(C>=vec(i))));
        end
    end
end

% Some debugging plots
% figure;
% semilogx(x,C,'o');
% for i=1:length(thresholds), line([thresholds(i) thresholds(i)],ylim);end


%fprintf('Computing threshold (of %d):    1',npoints);
%for i = 1:npoints
for j = 1:npoints,
    
    % Apply threshold
    %bwl = ims > i/npoints;
    bwl = ims > thresholds(j);
    
    %     if USE_ERODE_MASK,
    %         bwl2=bwl;
    %         for kk=1:size(bwl2,3),
    %             bwl2(:,:,kk)=bwl2(:,:,kk).*BW2;
    %         end
    %         bwl=bwl2;
    %     end
    % Find particles
    [lab,spot_num] = bwlabeln(bwl);
    %spot_pos = regionprops(lab, 'centroid');     %find the coordinates of each of the spot
    
    %     spot_xyz = NaN(spot_num,3);
    %     for s=1:1:spot_num
    %
    %         spot_xyz(s,1) = (spot_pos(s).Centroid(1,1));
    %         spot_xyz(s,2) = (spot_pos(s).Centroid(1,2));
    %         spot_xyz(s,3) = (spot_pos(s).Centroid(1,3));
    %
    %     end
    % Save count into variable nout
    nout(j) = spot_num;
    
    %fprintf('\b\b\b%3i',j);
    set(handles.text1,'String',['Counting dots at threshold ' num2str(j) ' of ' num2str(npoints) ]);drawnow;
end;
%fprintf('\n\n');
