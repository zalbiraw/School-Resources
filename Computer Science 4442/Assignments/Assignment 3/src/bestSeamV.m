function [seam,c] = bestSeamV(M,P)
seam = zeros(size(P, 1), 1);
[c, j] = min(M(size(M, 1), :));

seam(size(P, 1)) = j;
for i = size(P, 1): -1 : 2
    j = P(i, seam(i));
    seam(i - 1) = j;
end