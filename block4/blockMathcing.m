function [motion] = blockMathcing(img, refImg, blockSize, p)
% Computes Block Matching
%
% Input
%   img : The image for which we want to find motion vectors
%   refImg : The reference image
%   blockSize : Size of the blocks
%   p : Area of Search ((2p + 1) blocks vertically and horizontally)
%
% Ouput
%   motion :    motion(:,:,1) = 'displacement in the X-axis'
%               motion(:,:,2) = 'displacement in the Y-axis'


[row, col] = size(refImg);

% The image where we are going tu put the optical flow
motion = zeros(row, col, 2);
dX = zeros(row, col);
dY = zeros(row, col);

% To hold the Displaced Frame Difference between current block and the ones
% from the area of search
DFD = ones(2*p + 1, 2*p +1) * inf;

for i = 1 : blockSize : row-blockSize+1
    for j = 1 : blockSize : col-blockSize+1
        msg = sprintf('\t[%d,%d] ',i,j); %disp(msg);
        
        for m = -p : p        
            for n = -p : p
                refBlockVer = i + m;   % row/Vert coordinate for ref block
                refBlockHor = j + n;   % col/Horizontal coordinate
                if ( refBlockVer < 1 || refBlockVer+blockSize-1 > row || refBlockHor < 1 || refBlockHor+blockSize-1 > col)
                    continue;
                end
                DFD(m+p+1,n+p+1) = meanAbsoluteDifference(img(i:i+blockSize-1,j:j+blockSize-1), ...
                     refImg(refBlockVer:refBlockVer+blockSize-1, refBlockHor:refBlockHor+blockSize-1), blockSize);                
            end
        end
        
        [dx, dy, min] = minDFD(DFD); % finds which block give us the minimum
        dY(i:i+blockSize-1, j:j+blockSize-1) = dy-p-1;    % row co-ordinate for the vector
        dX(i:i+blockSize-1, j:j+blockSize-1) = dx-p-1;    % col co-ordinate for the vector
        
        DFD = ones(2*p + 1, 2*p +1) * inf;
    end    
end


motion(:,:,1) = dX;
motion(:,:,2) = dY;



function [dx, dy, min] = minDFD(costs)
% Obtain (dx,dy) for the minimum Displace Frame Difference
[row, col] = size(costs);
min = inf;

for i = 1:row
    for j = 1:col
        if (costs(i,j) < min)
            min = costs(i,j);
            dx = j; dy = i;
        end
    end
end

function cost = meanAbsoluteDifference(currentBlk, refBlk, n)
% Computes the Mean Absolute Difference for the given two blocks
err = 0;
for i = 1:n
    for j = 1:n
        err = err + abs((currentBlk(i,j) - refBlk(i,j)));
    end
end
cost = err / (n*n);
                    