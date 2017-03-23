function [aBest] = PerceptronBatch(Train1, Train2, k)
A = [[ones(size(Train1, 1), 1) Train1]; ([ones(size(Train2, 1), 1) Train2] * -1)];
a = ones(size(A, 2), 1);
best = size(A, 1);
for i = 1 : k,
    Axa = A * a;
    J = size(Axa(Axa < 0), 1);
    new_a = a + transpose(sum(A(find(Axa < 0), :), 1));
    
    if best >= J
        best = J;
        aBest = a;
    end
    a = new_a;
end