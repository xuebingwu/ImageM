function ncell = plot_all_cell(cell,scale,edge_color,label_color,labelfontsize)

ncell = length(cell);

if ncell
    if nargin <2
        scale = [1 1];
    end
    if nargin < 3
        edge_color = 'c';
    end
    if nargin <4
        label_color = 'y';
    end
    if nargin <5
        labelfontsize = 14;
    end
    hold on

    for i=1:ncell
        x = cell(i).edge(:,1)*scale(1);
        y = cell(i).edge(:,2)*scale(2);
        xc = cell(i).center(1)*scale(1);
        yc = cell(i).center(2)*scale(2);
        plot(x,y,'Color',edge_color(1),'Tag',['plot_cell_edge' num2str(i)]);
        text(xc,yc,cell(i).label,'FontSize',labelfontsize,'Color',label_color(1),'HorizontalAlignment','center','Tag',['plot_cell_label' cell(i).label])
    end
else
    disp('No cells!')
end