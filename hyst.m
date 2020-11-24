function Inew = hyst(I, tau_low, tau_high, b)

T_low = zeros(size(I));
for i = 1:size(I,1)
    for j = 1:size(I,2)
        if I(i, j) > tau_low
            T_low(i, j) = 1;
        else
            T_low(i, j) = 0;
        end
    end
end

T_high = zeros(size(I));
for i = 1:size(I,1)
    for j = 1:size(I,2)
        if I(i, j) > tau_high
            T_high(i, j) = 1;
        else
            T_high(i, j) = 0;
        end
    end
end

Inew = zeros(size(I));

if b
    for i = 1:size(I,1)
        for j = 1:size(I,2)
            if T_low(i, j) > 0 && T_high(i, j) > 0
                Inew(i, j) = 1;
            elseif T_low(i, j) > 0
                Inew(i, j) = 1;
            else
                Inew(i, j) = 0;
            end
        end
    end
else
    for i = 1:size(I,1)
        for j = 1:size(I,2)
            if T_low(i, j)==1
                for k = 1:size(I,1)
                    for l = 1:size(I,2)
                        if T_high(k, l) ==1
                            c = i+k;
                            d = j+l;
                            Inew(c,d) = 1;
                        end
                    end
                end
            end
        end
    end
end

end