function[CONF, error] = summarizeResults(C1, C2)
sizC1 = size(C1, 1);
sizC2 = size(C2, 1);

curC1 = (sum(C1) + sizC1) / 2;
curC2 = (sum(C2) - sizC2) / -2;

errC1 = (sizC1 - curC1);
errC2 = (sizC2 - curC2);

CONF = [curC1 errC1; errC2 curC2];
error = (errC1 + errC2) / (sizC1 + sizC2);