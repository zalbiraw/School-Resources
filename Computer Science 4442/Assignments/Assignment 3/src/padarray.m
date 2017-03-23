function [outIM] = padarray(im, pad)

y = pad(1);
x = pad(2);

outIM = zeros(size(im, 1) + 2 * y, size(im, 2) + 2 * x);

for i = 1 : size(im, 1)
    for j = 1 : size(im, 2)
        outIM(i + y, j + x) = im(i, j);
    end
end