function [im] = myIncreaseWidth(im, w, m, x, y)
E = applyRadialMask(computeEngGradH(im) + computeEngColor(im, w), m, x, y);
[M,P] = seamV_DP(E);
[seam,~] = bestSeamV(M,P);
[im] = addSeamV(im,seam);