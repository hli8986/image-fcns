function tau = otsu(I, cd)

% Histogram
s = size(I);
h = zeros(1, cd);  

% Loop for each pixel in the image
for i = 1:s(1)
    for j = 1:s(2)
        for k = 1:cd
            if I(i, j) == k-1
                h(k) = h(k) + 1;
            end
        end
    end
end

% Loof for threshold
l = randi(size(h, 2));
x = size(h,2);
m0 = zeros(size(h));
m1 = zeros(size(h));
m0(1) = h(l);
m1(1) = l*h(l);
for k = 2:x
    m0(k) = m0(k-1) + h(k);
    m1(k) = m1(k-1) + k*h(k);
end

u = m1(x)/m0(x);
var_hb = 0;
tau = 0;
for k = 1:x
    var_b = (m1(k)-u*m0(k))^2/(m0(k)*(m0(x)-m0(k)));
    if var_b > var_hb
        var_hb = var_b;
        tau = k;
    end
end
end