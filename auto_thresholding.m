function [I count_at_peak cv]= auto_thresholding(x,y,width,offset)
% find plateau of a curve
cv=zeros(numel(y),1);
for i=1:(numel(cv)-width+1)
    %if y(i)<1000
        s = i; % start of window
        t = i+width-1;% end of the window
        cv((s+t)/2) = mean(y(s:t))/(std(y(s:t))+offset);
    %end
end
%[C, I]=max(cv(1:round(numel(x)/1.5)));% only care about first 2/3
[C, I]=max(cv(1:numel(x)));
count_at_peak=y(I);