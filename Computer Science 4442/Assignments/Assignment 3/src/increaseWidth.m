function [seam, im, c, mask] = increaseWidth(im, w, mask, maskWeight)
E = computeEngGradH(im) + computeEngColor(im, w) + mask * maskWeight;
[M,P] = seamV_DP(E);
[seam,c] = bestSeamV(M,P);
mask = addSeamV(mask,seam);
im = addSeamV(im,seam);