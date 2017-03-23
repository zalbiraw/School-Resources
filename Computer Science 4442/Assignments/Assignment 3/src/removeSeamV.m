function [imOut] = removeSeamV(im,seam)
imOut = zeros(size(im, 1), size(im, 2) - 1, size(im, 3));
for i = 1 : size(im, 1)
    imOut(i, 1:seam(i) - 1, :) = im(i, 1:seam(i) - 1, :);
    imOut(i, seam(i):size(imOut, 2), :) = im(i, seam(i) + 1:size(im, 2), :);
end