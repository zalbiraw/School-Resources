function [C1, C2] = LinearMSE(Train1, Train2, Test1, Test2)

a = sum(pinv([[ones(size(Train1, 1), 1) Train1]; [(ones(size(Train2, 1), 1)) Train2] * -1]), 2);

C1 = sign([ones(size(Test1, 1), 1) Test1] * a);
C2 = sign([ones(size(Test2, 1), 1) Test2] * a);