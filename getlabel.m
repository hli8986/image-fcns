function anew = getlabel(a, equiv)

% Assists connected component labeling algorithm
if a == equiv(a)
    anew = a;
else
    equiv(a) = getlabel(equiv(a));
    anew = equiv(a);
end
end