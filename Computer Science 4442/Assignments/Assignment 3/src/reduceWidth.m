function [seam, im, c, mask] = reduceWidth(im, w, mask, maskWeight)
E = computeEngGradH(im) + computeEngColor(im, w) + mask * maskWeight;
[M,P] = seamV_DP(E);
[seam,c] = bestSeamV(M,P);
mask = removeSeamV(mask,seam);
im = removeSeamV(im,seam);