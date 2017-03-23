function [outIM] = applyMask(im,M)
y = floor(size(M, 1)/2);    
x = floor(size(M, 2)/2);

outIM = im;
im = padarray(im, [y x]);

for i = y + 1: size(im, 1) - y
    for j = x + 1: size(im, 2) - x
        outIM(i - y, j - x) = sum(sum(M .* im(i - y:i + y, j - x:j + x)));
    end
end

%imwrite(uint8(stretch(outIM)),'swanFiltered.png');
%sum(sum(abs(outIM)))