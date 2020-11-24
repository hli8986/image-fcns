function Iedge = myCannyEdgeDetector(I, sigma, tlow, thigh)
% This function finds the edges using Canny edge detector. There are four
% inputs required and one output from the function.
% Created by Hao Li (haoli1@ufl.edu)

% Input:
% I     - a grayscale image
% sigma - sigma value of Gaussian filter
% tlow  - lower threshold for linking edges
% thigh - higher threshold for linking edges

% Outpupt:
% Iedge - a RGB image with only the edges being blue

% close all

%% Image Gradient
figure
% Smooth the image
gfilt = imgaussfilt(I, sigma, 'FilterSize', 3);

% Find the gradients in x, y direction
[gx, gy] = imgradientxy(gfilt, 'sobel');

% Find phase and magnitude
gpha = atan2(gy, gx);
[gmag, ~] = imgradient(gfilt, 'sobel');

% Display gradient images
% figure (1)
% montage({uint8(gmag), gpha, uint8(gmag)>100}, 'Size', [1 3])

%% Non-maximal suppression

smag = size(gmag);
glmax = zeros(smag(1), smag(2));
for i = 2 : smag(1)-1
    for j = 2 : smag(2)-1
        theta = gpha(i, j);
        
        % Ensure theta within the range
        if theta >= 7*pi/8
            theta = theta - pi;
        end
        
        if theta < -pi/8
            theta = theta + pi;
        end
        
        % Find and store neighbour values
        if theta >= -pi/8 && theta < pi/8
            neigh1 = gmag(i-1, j);
            neigh2 = gmag(i+1, j);
        elseif theta >= pi/8 && theta < 3*pi/8
            neigh1 = gmag(i-1, j-1);
            neigh2 = gmag(i+1, j+1);
        elseif theta >= 3*pi/8 && theta < 5*pi/8
            neigh1 = gmag(i, j-1);
            neigh2 = gmag(i, j+1);
        elseif theta >= 5*pi/8 && theta < 7*pi/8
            neigh1 = gmag(i-1, j+1);
            neigh2 = gmag(i+1, j-1);
        end
        
        % Compare neighbors for local maximum
        if gmag(i, j) >= neigh1 && gmag(i, j) >= neigh2
            glmax(i, j) = gmag(i, j);
        else
            glmax(i, j) = 0;    % Set 0 if not max
        end
    end
end     

%% Edge linking

% Filter with higher than low threshold
above_low = glmax > tlow;

% Find coordinates over high threshold
[high_x, high_y] = find(glmax > thigh);

% Connect all edges
Inew = bwselect(above_low, high_y, high_x);

% Paint the edge image blue
I3 = I + uint8(Inew)*255;
Iedge = cat(3, I, I, I3);

% Display image with edge
imshow(Iedge)
title('Original Image with Edges', 'FontSize', 15)

% figure(2)
% imshow(Inew)

end
