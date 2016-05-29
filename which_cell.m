function found = which_cell(point,cell)
% find the first cell that contains the point

found = 0;
n = 0;
while found==0 & n<length(cell)
    n = n + 1;
    if inpoly(point,cell(n).edge,[],0.01)
        found = n;
        break;
    end
end