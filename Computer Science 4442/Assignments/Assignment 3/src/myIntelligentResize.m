function [imOut] = myIntelligentResize(im, v, h, w, m, x, y)
imOut = im;
while v ~= 0 || h ~= 0
    if v > 0
        imOut = myIncreaseWidth(imOut, w, m, x, y);
        v = v - 1;
    elseif v < 0
        imOut = myReduceWidth(imOut, w, m, x, y);
        v = v + 1;
    end
    if h > 0
        imOut = myIncreaseHeight(imOut, w, m, x, y);
        h = h - 1;
    elseif h < 0
        imOut = myReduceHeight(imOut, w, m, x, y);
        h = h + 1;
    end
end