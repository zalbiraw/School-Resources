function [seam, im, c, mask] = reduceHeight(im, w, mask, maskWeight)
im = permute(im, [2 1 3]);
mask = transpose(mask);
E = computeEngGradH(im) + computeEngColor(im, w) + mask * maskWeight;
[M,P] = seamV_DP(E);
[seam,c] = bestSeamV(M,P);
mask = transpose(removeSeamV(mask,seam));
im = permute(removeSeamV(im,seam), [2 1 3]);