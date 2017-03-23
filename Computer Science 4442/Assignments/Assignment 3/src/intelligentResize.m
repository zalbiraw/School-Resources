function [imOut] = intelligentResize(im, v, h, w, mask, maskWeight)
imOut = im;
totalC = 0;
while v ~= 0 || h ~= 0
    if v > 0
        [~, imOut, c, mask] = increaseWidth(imOut, w, mask, maskWeight);
        v = v - 1;
        totalC = totalC + c;
    elseif v < 0
        [~, imOut, c, mask] = reduceWidth(imOut, w, mask, maskWeight);
        v = v + 1;
        totalC = totalC + c;
    end
    if h > 0
        [~, imOut, c, mask] = increaseHeight(imOut, w, mask, maskWeight);
        h = h - 1;
        totalC = totalC + c;
    elseif h < 0
        [~, imOut, c, mask] = reduceHeight(imOut, w, mask, maskWeight);
        h = h + 1;
        totalC = totalC + c;
    end
end
%totalC