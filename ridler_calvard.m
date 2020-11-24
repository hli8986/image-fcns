function tau = ridler_calvard(I, cd)

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

% Loop for threshold
x = size(h,2);
m0 = zeros(size(h));
m1 = zeros(size(h));
m0(1) = h(1);
m1(1) = 0;
for i = 2:x
    m0(i) = m0(i-1) + h(i);
    m1(i) = m1(i-1) + i*h(i);
end

tau = x/2;
tau_c = x/2;

while x
    u1 = m1(tau)/m0(tau);
    u2 = (m1(x) - m1(tau))/(m0(x) - m0(tau));
    tau = round(0.5*(u1+u2));
    if (tau_c-tau) == 0
        fprintf('tau is ready: %d\n', tau)
        break
    end
    tau_c = tau;
end

end