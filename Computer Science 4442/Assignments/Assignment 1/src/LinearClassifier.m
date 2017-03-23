function [C1, C2] = LinearClassifier(a, Test1, Test2) 

C1 = sign([ones(size(Test1, 1), 1) Test1] * a);
C2 = sign([ones(size(Test2, 1), 1) Test2] * a);