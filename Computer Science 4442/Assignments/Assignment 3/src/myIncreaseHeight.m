function [im] = myIncreaseHeight(im, w, m, x, y)
im = permute(im, [2 1 3]);
E = applyRadialMask(computeEngGradH(im) + computeEngColor(im, w), m, x, y);
[M,P] = seamV_DP(E);
[seam,~] = bestSeamV(M,P);
im = permute(addSeamV(im,seam), [2 1 3]);