function [cell2 I] = reorder_cells(cell,skeleton)
% re-order cells along a skeleton
%   cell.center   N points in 2D, the center of the cells
%   skeleton      M points in 2D, the skeleton. each row is a point 

% algorithm: treat the skeleton as a seris of ordered line segments,
% each providing a baseline for nearby cells to project onto. For each
% cell and line segment pair, first check whether the cell is projected 
% inside the line segment or not. If so, calculate the distance to each
% the line segment, otherwise set it to infinite. Find the nearest line 
% segment for each cell, and order cells projected to the same line segment
% by projected distance to the first point of the line segment. Since line
% segment are also ordered, cells projected to different line segments are
% automatically ordered.

% number of cells
n = length(cell);

% number of line segments in the skeleton
m = size(skeleton,1)-1;

% calculate the distance of point to line segment
D = zeros(m,n);

for i=1:m
    for j=1:n
        D(i,j) = point2line(cell(j).center,skeleton(i,:),skeleton(i+1,:));
    end
end
D

% find the nearest line segment
[C I] = min(D,[],1)

% compute the distance (along the line segment) of the projected cell to 
% the first point of the nearest line
D2 = zeros(1,n);
for i=1:n 
    D2(i) = ((cell(i).center-skeleton(I(i),:))*(cell(i).center-skeleton(I(i),:))' - C(i)^2)^0.5;
end
D2

% weight to order each line segment, make sure the difference of line 
% segment is largle enough. 
wv = 100.^(1:m);

% the final weight for each cell is the product of line segment weight and 
% cell weight within a line segment. 
w = D2.*wv(I);
w

[a b] = sort(w);

cell2 = cell(b);

function d = point2line(P, Q1,Q2)
% calculate the distance of a point to a line segment.
% require the point to be projected within the line segment
if (P-Q2)*(Q1-Q2)' > 0 & (P-Q1)*(Q2-Q1)' > 0 
    d = abs(det([Q2-Q1;P-Q1]))/norm(Q2-Q1);
else
    d = 10^9;
end






