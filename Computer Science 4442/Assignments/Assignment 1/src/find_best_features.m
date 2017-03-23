function[set] = find_best_features(HamTrain, SpamTrain, HamTest, SpamTest, k)

err = 1;
for i = 1 : 97,
    [c1, c2] = classifyKnn(HamTrain, SpamTrain, HamTest, SpamTest, k, i, (i + 2));
    [~, d] = summarizeResults(c1, c2);

    if d < err
        err = d;
        set = [i (i + 1) (i + 2)];
    end
end