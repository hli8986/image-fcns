function Ins = myFrequencyFilt(I, k)
% This function perform 2D convolution on input image with Gaussian filter
% in the frequency domain. Before filtering, the 2D shifted DFT image is
% presented in terms of logrithm magnitude and phase.
% Creator: Hao Li (haoli1@ufl.edu)

% Input:
% I: A grayscle image with any size
% k: Gaussian kernel size with respect to height k(1) and width k(2).
%    Kernel size is expected to be odd numebrs.

% Outpt:
% Ins: Filtered image, about the same size of the input image

%% 
% Define kernel height and width
h = k(1);
w = k(2);

% Calculate half width
half_h = (h-1)/2;
half_w = (w-1)/2;
if h > w
    sigma = h/6;
elseif h < w
    sigma = w/6;
elseif h == w
    sigma = w/6;
end

% Create gaussian
gauss = zeros(h, w);
for i = 1:h
    for j = 1:w
        gauss(i, j) = exp(-((i-half_h-1)^2+(j-half_w-1)^2)/(2*sigma^2));
    end
end

% Pad image if necessary
sz = size(I);
if rem(sz(1),2)||rem(sz(2),2)
    I = padarray(I, [1 1], 0, 'post');
end

% Pad Gaussian kernel with zeros
sz = size(I);
gaussp = padarray(gauss, [sz(1)-h+1, sz(2)-w+1]/2, 0, 'both');
gaussp = gaussp(1:end-1, 1:end-1);

% Convert image and kernel to frequency domain
Y = fft2(I);
Yg = fft2(gaussp);

% Shift frequnecy image to center
quad1 = Y(1:end/2, 1:end/2); 
quad2 = Y(1:end/2, end/2+1:end); 
quad3 = Y(end/2+1:end, 1:end/2); 
quad4 = Y(end/2+1:end, end/2+1:end);
Ys = [quad4 quad3; quad2 quad1];

% Calculate and present the magnitude and phase
mag = (abs(Ys)/max(max(abs(Ys))))*255;
phase = (angle(Ys)/max(max(angle(Ys))))*255;
figure(1), imshow(log10(mag))
title('2D DFT shifted image in magnitude', 'FontSize', 15)
figure(2), imshow(phase)
title('2D DFT shifted image in phase', 'FontSize', 15)

% Perform convolution
Yn = Y.*Yg;

% Transfer back spatial domain
In = real(ifft2(Yn));
In = (In/max(max(In)))*255;
In = uint8(In);

% Rearrange the image
quadn1 = In(1:end/2, 1:end/2); 
quadn2 = In(1:end/2, end/2+1:end); 
quadn3 = In(end/2+1:end, 1:end/2); 
quadn4 = In(end/2+1:end, end/2+1:end); 
Ins = [quadn4 quadn3; quadn2 quadn1];

figure(3), imshow(Ins)
title('Convolved Image using Frequnecy Gaussian Filter', 'FontSize', 17)

end