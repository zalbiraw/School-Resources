function [eng] = computeEngGradH(im)
M = [1 0 -1];
eng = abs(applyMask(im(:, :, 1), M)) + abs(applyMask(im(:, :, 2), M)) + abs(applyMask(im(:, :, 3), M));
%imwrite(uint8(stretch(eng)),'faceEngG.jpg');
%sum(sum(abs(eng)))