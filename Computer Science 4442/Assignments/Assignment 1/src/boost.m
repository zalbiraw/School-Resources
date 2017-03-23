function [features, thresholds, polarities, alphas] = boost(Train1, Train2, t)

train = [Train1; Train2];
class = [ones(size(Train1, 1), 1); zeros(size(Train1, 1), 1) - 1];
weights = ones(size(train, 1), 1);

features    = zeros(t, 1);
thresholds  = zeros(t, 1);
polarities  = zeros(t, 1);
alphas      = zeros(t, 1);

for i = 1 : t
    
    best_divider = 0.5;
    weights = weights ./ sum(weights);
    
    for j = 1 : size(train, 2),

        divider = 0.5;
        threshold_set = unique(train(:, j));
        
        for z = 1 : size(threshold_set, 1) - 1,
            new_threshold = (threshold_set(z) + threshold_set(z + 1)) / 2;
            miss_class1 = sum(weights(find(class(find(new_threshold >  train(:, j))) == -1)));
            miss_class2 = sum(weights(find(class(find(new_threshold <= train(:, j))) ==  1)));
            new_divider = miss_class1 + miss_class2;

            flipped = 0;
            if (new_divider > 0.5)
                flipped = 1;
                 
                miss_class1 = sum(weights(find(class(find(new_threshold <= train(:, j))) == -1)));
                miss_class2 = sum(weights(find(class(find(new_threshold >  train(:, j))) ==  1)));
                new_divider = miss_class1 + miss_class2;
            end

            if (divider >= new_divider)
                divider = new_divider;
                feature = j;
                threshold = new_threshold;

                if (flipped == 1)
                    polarity = -1;
                else
                    polarity = 1;
                end
            end
        end

        if (best_divider >= divider)
            best_divider    = divider;
            features(i)     = feature;
            thresholds(i)   = threshold;
            polarities(i)   = polarity;
            alphas(i)       = 0.5 * log((1 - divider) / divider);
        end
    end
    
    result_class = sign(thresholds(i) - train(:, j));
    for x = 1 : size(weights, 1),
        weights(x) = weights(x) * exp((-alphas(i)) * class(x) * result_class(x));
    end
end