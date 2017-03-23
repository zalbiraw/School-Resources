function [E] = applyRadialMask(E, m, x, y)

cY = ceil(size(E, 1)/2);
cX = ceil(size(E, 2)/2);

for j = cY - floor(y / 2) : cY + floor(y / 2)
    for i = cX - floor(x / 2) : cX + floor(x / 2)
        E(j, i) = E(j, i) * (1 + m * (1 - ((sqrt((cX - i)^2 + (cY - j)^2)) / max (x, y))));
    end
end