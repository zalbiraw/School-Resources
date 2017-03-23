function [C1, C2] = QuadraticMSE(Train1, Train2, Test1, Test2)

init_features = size(Train1, 2) + 1;
block_size = 21;

set = [Train1; Train2; Test1; Test2];
new_set = zeros(size(set, 1), ((init_features - block_size) * block_size));

for i = 1 : size(set, 1),
    new_set(i, :) = feature_generator(set(i, :), init_features, block_size);
end

set = [set new_set];

acc_size = size(Train1, 1);
Train1 = set(1 : acc_size, :);
Train2 = set(acc_size + 1 : acc_size + size(Train2, 1), :); acc_size = acc_size + size(Train2, 1);
Test1  = set(acc_size + 1 : acc_size + size( Test1, 1), :); acc_size = acc_size + size( Test1, 1);
Test2  = set(acc_size + 1 : acc_size + size( Test2, 1), :);

[C1, C2] = LinearMSE(Train1, Train2, Test1, Test2);