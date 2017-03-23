function [eng] = computeEngColor(im, w)
eng = im(:, :, 1) * w(1) + im(:, :, 2) * w(2) + im(:, :, 3) * w(3);
%imwrite(uint8(stretch(eng)),'catEngC.png');
%sum(sum((eng)))