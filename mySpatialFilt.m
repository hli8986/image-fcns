function I_new = mySpatialFilt(I, k)
% This function perform 2D convolution on input image with Gaussian filter
% in the spatial domain. As the image and kernel size increases, the time
% required increases.
% Creator: Hao Li (haoli1@ufl.edu)

% Input:
% I: A grayscle image with any size
% k: Gaussian kernel size with respect to height k(1) and width k(2).
%    Kernel size is expected to be odd numebrs.

% Output:
% I_new: Filtered image, about the same size of the input image

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

% Handle edges by mirror reflections
I_mod = padarray(I, [h+1, w+1]/2, 'symmetric', 'both');
I_mod = double(I_mod);
    
% Create Gaussian kernel
gauss = zeros(h, w);
for i = 1:h
    for j = 1:w
        gauss(i, j) = exp(-((i-half_h-1)^2+(j-half_w-1)^2)/(2*sigma^2));
    end
end

% Convolve with 2D Gaussian kernel
I_new = zeros(size(I), 'double');
for i = (1+half_h):(size(I_mod, 1)-half_h)
    for j = (1+half_w):(size(I_mod, 2)-half_w)
        val = 0;
        for m = 1:h
            for n = 1:w
                val = val + gauss(m, n)*I_mod(i+half_h-m+1, j+half_w-n+1);
            end
            I_new(i-half_h, j-half_w) = val;
        end
    end
end
I_new = uint8((I_new/max(max(I_new)))*255);
figure, imshow(I_new)
title('Convolved Image using Spatial Gaussian Filter', 'FontSize', 17)

end