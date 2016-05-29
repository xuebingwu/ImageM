function [uid id T]=find_background_dots(dots,b)
% the function returns the indices (row numbers) of dots that are present in at least
% two channels. Two dots are identified as the same if their distance
% (Euclidean) in 3D space is less thant a given threshold b*T, where T is the minimum pairwise distance of dots in the same channel. 
% uid: unique element in id

% if no threshold coefficient specified
if nargin < 2
    b = 1;
end

T = b*find_threshold(dots);
disp(['default threshold = ' num2str(T)])

id = [];

% number of channels
nc = numel(unique(dots(:,4)))
% index vector
posi = 1:size(dots,1);

for i=1:nc% the first channel
    ps1 = posi(dots(:,4)==i);%indices for dots in the second channael
    for j=(i+1):nc% the second channel
        ps2 = posi(dots(:,4)==j);% indices for dots in the second channel
        for m = 1:numel(ps1)% each dots in the first channel
            for n=1:numel(ps2) % each dots in the second channel
                if norm(dots(ps1(m),1:3)-dots(ps2(n),1:3)) < T % distance < threshold
                    id = [id ps1(m) ps2(n)];%
                end
            end
        end
    end
end

uid = unique(id);    

function d = find_threshold(dots)
% find the minimum pairwise distance between any two dots in the same channel.
d = 10^9;
nc = numel(unique(dots(:,4)));
for i=1:nc
    d
    x = dots(dots(:,4)==i,1:3);
    y = pdist(x);    
    m = min(y);
    if d > m
        d = m;
    end
end