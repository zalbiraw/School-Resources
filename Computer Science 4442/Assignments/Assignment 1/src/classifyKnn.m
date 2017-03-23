function [C1, C2] = classifyKnn(Train1, Train2, Test1, Test2, k, x, y)

train_set   = [Train1; Train2];
test_set    = [Test1 ; Test2 ];
train_class = [ones(size(Train1, 1), 1);ones(size(Train2, 1), 1) + 1];

result = ones(size(test_set, 1), 1);

for i = 1 : size(test_set, 1),

    eclu = repmat(test_set(i, :), size(train_set, 1), 1);
    set = sqrt(sum((train_set(:, x:y) - eclu(:, x:y)).^2, 2));
    
    class1 = 0;
    class2 = 0;
    max_val = max(set);
    for j = 1 : k,
        index = find(set == min(set));
        
        if train_class(index(1)) == 1
            class1 = class1 + 1;
        else
            class2 = class2 + 1;
        end
        set(index(1)) = max_val;
    end
    
    if class1 < class2 
        result(i) = -1;
    end
end

C1 = result(1 : size(Test1, 1), :);
C2 = result(size(Test1, 1) + 1 : size(test_set, 1), :);