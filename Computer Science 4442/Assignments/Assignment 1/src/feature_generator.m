function [feature] = feature_generator(data, i, j)

feature = zeros(j, i - j);
for i = 1 : size(feature, 2),
    feature(:, i) = data(i) * data(i : (i + j - 1));
end
feature = transpose(feature(:));