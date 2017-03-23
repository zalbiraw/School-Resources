%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Performs foreground/background segmentation based on a graph cut
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% INPUT: image im and scribbleMask with scribbles
% scribbleMask(i,j) = 2 means pixel(i,j) is a foreground seed
% scribbleMask(i,j) = 1 means pixel(i,j) is a background seed
% scribbleMask(i,j) = 0 means pixel(i,j) is not a seed
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% OUTPUT: segm is the segmentation mask of the  same size as input image im
% segm(i,j) = 1 means pixel (i,j) is the foreground
% segm(i,j) = 0 means pixel (i,j) is the background
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function segm  = segmentGC(im,scribbleMask)
[row, col, ~] = size(im);
dataF = zeros(1, row * col);
dataB = zeros(1, row * col);
W = zeros(8 + 6 * (row + col - 4) + 4 * (row - 2) * (col - 2), 3);
z = 1;
for i = 1 : row * col
    if scribbleMask == 1
        dataF(i) = 1000;
    elseif scribbleMask == 2
        dataB(i) = 1000;
    end
        
    N = 0;
    sigma = 0;
    y = mod(i - 1, row) + 1;
    x = floor((i - 1) / row) + 1;
    
    if y > 1
        sigma = sigma + sqrt(sum((im(y, x) - im(y - 1, x)).^2));
        N = N + 1;
    end
    if y < row - 1
        sigma = sigma + sqrt(sum((im(y, x) - im(y + 1, x)).^2));
        N = N + 1;
    end
    if x > 1
        sigma = sigma + sqrt(sum((im(y, x) - im(y, x - 1)).^2));
        N = N + 1;
    end
    if x < col - 1
        sigma = sigma + sqrt(sum((im(y, x) - im(y, x + 1)).^2));
        N = N + 1;
    end
        
    sigma = sigma / N;
    if y > 1
        w = exp(-(sum((im(y, x) - im(y - 1, x)).^2) / (2 * sigma^2)));
        W(z, :) = [i  i - 1 w];
        W(z + 1, :) = [i - 1  i w];
        z = z + 2;
    end
    if x > 1
        w = exp(-(sum((im(y, x) - im(y, x - 1)).^2) / (2 * sigma^2)));
        W(z, :) = [i  i - row w];
        W(z + 1, :) = [i - row  i w];
        z = z + 2;
    end
end
labels = solveMinCut(dataB, dataF, W);
segm = zeros(row, col);
for i = 1 : row * col
    segm(mod(i - 1, row) + 1, floor((i - 1) / row) + 1) = labels(i);
end