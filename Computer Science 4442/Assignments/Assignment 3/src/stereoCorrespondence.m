function disp = stereoCorrespondence(left, right, wSize, maxDisp)
disp = zeros(size(left));
best = 10000 * ones(size(left));
for i = 0 : maxDisp + 1
    absDiff = abs(right(:, 1:size(right, 2) - i) - left(:, i + 1:size(left, 2)));
    integral = zeros(size(left, 1), size(left, 2) - i);
    integral(1, 1) = absDiff(1, 1);
    for j = 2 : size(absDiff, 1)
        integral(j, 1) = absDiff(j, 1) + integral(j - 1, 1);
    end
    for z = 2 : size(absDiff, 2)
        integral(1, z) = absDiff(1, z) + integral(1, z - 1);
    end
    for j = 2 : size(absDiff, 1)
        for z = 2 : size(absDiff, 2)
            integral(j, z) = absDiff(j, z) + integral(j - 1, z) + integral(j, z - 1) - integral(j - 1, z - 1);
        end
    end
    
    integral = [zeros(size(left, 1), i) integral];
    for j = ceil(wSize/2) : size(disp, 1) - floor(wSize/2)
        for z = ceil(wSize/2) : size(disp, 2) - floor(wSize/2)
            curr = 0;
            
            if (j - ceil(wSize/2)) > 1 && (z - ceil(wSize/2)) > 1
                curr = curr + integral(j - ceil(wSize/2), z - ceil(wSize/2));
            end
            
            if (j - ceil(wSize/2)) > 1
                curr = curr - integral(j - ceil(wSize/2), z + floor(wSize/2));
            end
            
            if (z - ceil(wSize/2)) > 1
                curr = curr - integral(j + floor(wSize/2), z - ceil(wSize/2));
            end
            
            curr = curr + integral(j + floor(wSize/2), z + floor(wSize/2));
            if (curr < best(j, z))
                disp(j, z) = i;
                best(j, z) = curr;
            end
        end
    end
end