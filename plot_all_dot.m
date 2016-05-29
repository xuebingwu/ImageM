function ndot = plot_all_dot(dots,scale,marker)

ndot = length(dots)
if ndot
    hold on;
    col='rgbm';

    if nargin <2
        scale = [1 1];
    end
    if nargin <3
        marker = '+';
    end
    scale
    dots(:,1) = dots(:,1)*scale(1);
    dots(:,2) = dots(:,2)*scale(2);
    n_channel=numel(unique(dots(:,4)));
    n_channel
    for i=1:n_channel
        %i
        p = dots(dots(:,4)==i,:);
        %p
        plot(p(:,1),p(:,2),marker,'Color',col(i),'Tag','plot_dot');
    end
else
    disp('No dots!')
end