function Y = cell_count_normalization(X,method,cellvol)
% normalize dot counts in cell
% X:    #dots in each cell in each channel. each row is a cell, each column is
%       a channel
% method:   normalization method
% cellvol: cell volume

[n_cell, n_channel]= size(X);
Y=X;
switch method
    case 'bycell'
        % for each channel, divide the counts in each cell by the max
        % cell counts in the channel
        for i=1:n_channel
            Y(:,i)=X(:,i)/max([max(X(:,i)) 1]);
        end
    case 'bychannel'
        % for each cell, divide the counts in each channel by the max
        % channel counts of the cell
        for i=1:n_cell
            Y(i,:)=X(i,:)/max([max(X(i,:)) 1]);
        end
    case 'bytotal'
        % for each cell, divide the counts in each channel by the total
        % channel counts in the cell
        for i=1:n_cell
            Y(i,:)=X(i,:)/max([sum(X(i,:)) 1]);
        end
    case 'bysize'
        % for each cell, divide each channel counts by the cell volume. 
        for i=1:n_cell
            Y(i,:)=X(i,:)/cellvol(i);
        end
    otherwise % default: no normalization
        %Y=X;
end