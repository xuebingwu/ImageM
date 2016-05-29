function cell2 = set_cell_label(cell,origin)
% set cell label relative to origin

if nargin < 2
    origin = 0;
end

% label by order
for i=1:length(cell)
    cell(i).label = num2str(i-origin);
end

cell2=cell;