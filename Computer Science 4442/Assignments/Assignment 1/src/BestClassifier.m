function [C1, C2] = BestClassifier(Test1, Test2)

load('myData');
t1 = [HamTrain; HamTest];
t2 = [SpamTrain; SpamTest];
b = ones((size(t1, 1) + size(t2, 1)), 1);

for i = 1 : 1000
    b = b / sum(b);
    a = pinv([[ones(size(t1, 1), 1) t1]; [(ones(size(t2, 1), 1)) t2] * -1]) * b;
end

a = (a + PerceptronBatch(t1, t2, 100000))/2;

C1 = sign([ones(size(Test1, 1), 1) Test1] * a);
C2 = sign([ones(size(Test2, 1), 1) Test2] * a);