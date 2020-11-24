function [Ic, C] = myHarrisCornerDetector(I, sigma, k, m_size, the)
% This function finds the corners using Harris corner detection. There are 
% five inputs required and two outputs from the function.
% Created by Hao Li (haoli1@ufl.edu)

% Input:
% I         - a grayscale image
% sigma     - sigma value of Gaussian filter
% k         - Parameter for Harris cornerness formula
% m_size    - size of neighbor set during non-maximum suppression
% the       - threshold for cornerness

% Outpupt:
% Ic    - a RGB image with only the corners being blue
% C     - a matrix of x,y coordinates corresponding the corners

% close all

%% Image Gradient
figure
% Compute gradient in x, y directions
[gx, gy] = imgradientxy(I, 'sobel');

%% Smooth the gradients with Gaussian filter

% Create Gaussian filter
gauss = fspecial('gaussian', [3 3], sigma);

% Smooth gradients along with computing for Harris matrix
Ix2 = conv2(gx.^2, gauss, 'same');
Iy2 = conv2(gy.^2, gauss, 'same');
Ixy = conv2(gx.*gy, gauss,'same');

% Compute determinant and trace
% Since the Harris matrix could be non-square matrix, the function det()
% and trace() will be unavailable. Thus using the components of Harris
% matrix to direcly calculate the values
det_z = Ix2.*Iy2 - Ixy.^2;
trace_z = Ix2 + Iy2;

%% Compute cornerness and non-maximum suppression

% Harris cornerness formula
cor = det_z - k * trace_z.^2;

% Perform non-maximum suppression
mask = ordfilt2(cor, m_size^2, ones(m_size));

% Threshold the image with non-maximum suppression
fprintf('Current maximum cornerness is %d\n', max(max(cor)))
cor2 = (cor == mask) & (cor > the) ;
[y, x] = find(cor2);
C = [x, y];

% Display the image with red stars representing corners
imshow(I)
hold on
plot(C(:, 1), C(:, 2), 'r*')
title('Original Image with Corners', 'FontSize', 15)

% Store and return the image with corners
Inew = bwselect(cor2, x, y);
I3 = I + uint8(Inew)*255;
Ic = cat(3, I3, I, I);
% imshow(Ic)

% Threshold the image without non-maximum suppression
% cor3 = (cor >= the);
% [r2, c2] = find(cor3);
% imshow(I)
% hold on
% plot(c2, r2, 'r*')
% title('Corner detection withour non-maximum suppression', 'FontSize', 15)

end
