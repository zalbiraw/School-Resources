function [seam, im, c, mask] = increaseHeight(im, w, mask, maskWeight)
im = permute(im, [2 1 3]);
mask = transpose(mask);
E = computeEngGradH(im) + computeEngColor(im, w) + mask * maskWeight;
[M,P] = seamV_DP(E);
[seam,c] = bestSeamV(M,P);
mask = transpose(addSeamV(mask,seam));
im = permute(addSeamV(im,seam), [2 1 3]);