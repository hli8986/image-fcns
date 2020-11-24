function h = myhist(I)
% Hao Li
% haoli1

% Preparation
s = size(I);    % Acquire the size of the image matrix
h = zeros(1, 256);  % Define histogram with zeros

% Loop for each pixel in the image
for i = 1:s(1)
    for j = 1:s(2)
        for k = 1:256
            if I(i, j) == k-1
                % Count the number of pixels for each intensity value
                h(k) = h(k) + 1;
            end
        end
    end
end

% Plot the histogram
figure
plot(0:255, h)
hold on
bar(0:255, h, 0.3) 
title('Histogram for Intensity Image')
xlabel('Intensity value')
ylabel('Number of pixel')
end

% Based on the three histograms from each image, it seems that the mix
% image is the positive adding the negative. However, the intensity value
% does not show a simple addition. There must be some other operation. But
% overall, the mixed image does look like a mixture of the postivie image
% and the negative image since the lower intensity value is the same as the
% lower region in the positive image while the higher values look highly
% similar to the higher region in the negative image. The regions above 200
% in both postivie and negative image seem a subtraction occured basecause
% the mixed image has a relatively low number of pixels in that range.
