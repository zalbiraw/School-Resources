function [M,P] = seamV_DP(E)
M = zeros(size(E));
P = zeros(size(E));

M(1, :) = E(1, :);
for r = 2 : size(E, 1)
    for c = 1 : size(E, 2)
        op2 = M(r - 1, c);
        if (c > 1 && c < size(E, 2))
            op1 = M(r - 1, c - 1);
            op3 = M(r - 1, c + 1);
            if (op1 <= op2 && op1 <= op3)
                M(r, c) = E(r, c) + op1;
                P(r, c) = c - 1;
            elseif (op2 <= op1 && op2 <= op3)
                M(r, c) = E(r, c) + op2;
                P(r, c) = c;
            else
                M(r, c) = E(r, c) + op3;
                P(r, c) = c + 1;
            end
        elseif (c > 1)
            op1 = M(r - 1, c - 1);
            if (op1 <= op2)
                M(r, c) = E(r, c) + op1;
                P(r, c) = c - 1;
            else
                M(r, c) = E(r, c) + op2;
                P(r, c) = c;
            end
        elseif (c < size(E, 2))
            op3 = M(r - 1, c + 1);
            if (op2 <= op3)
                M(r, c) = E(r, c) + op2;
                P(r, c) = c;
            else
                M(r, c) = E(r, c) + op3;
                P(r, c) = c + 1;
            end
        end
    end
end