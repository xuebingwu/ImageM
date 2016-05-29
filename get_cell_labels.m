function labels = get_cell_labels(cells)

ncell = length(cells);

for i=1:ncell
    labels{i} = cells(i).label;
end