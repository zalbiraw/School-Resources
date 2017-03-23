function [imOut] = addSeamV(im,seam)

imOut = zeros(size(im, 1), size(im, 2) + 1, 3);

for i = 1 : size(im, 1)
    imOut(i, 1:seam(i), :) = im(i, 1:seam(i), :);
    imOut(i, seam(i) + 1:size(imOut, 2), :) = im(i, seam(i):size(im, 2), :);
end