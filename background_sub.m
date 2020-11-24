function background_sub(v, thres)
% This function performs background subtraction of a video. Nothing will
% be returned but the background and 5 randomly picked thresholded images.
% The backgroud is picked from the first 100 frames using average values.
%                ---- Created by Hao Li (haoli1@ufl.edu)

% Inputs:
% v: VideoReader object
% thres: A [1x5] threshold vector, default: [20, 20, 20, 20, 20]

close all

if ~exist('thres', 'var')
     thres = [20 20 20 20 20];
end
 
% Set the video to the beginning
v.CurrentTime = 0;

% Frame initialization
frame = readFrame(v);
frames = zeros([size(frame), 100], 'uint8');
g_frames = zeros([v.Height, v.Width, 1, 100], 'uint8');

% Read for the first 100 frames
for i = 1:100
    frames(:, :, :, i) = readFrame(v);
    % Perform grayscale transformation
    g_frames(:, :, :, i) = (double(frames(:, :, 1, i)) + ...
        double(frames(:, :, 2, i)) + double(frames(:, :, 3, i)))/3;
end

% implay(g_frames, v.FrameRate)
% implay(frames, v.FrameRate)

% Calculate average image
bg = uint8(mean(g_frames, 4));

% % Exhibit the background image
% figure(1), imshow(bg)
% title('Average Image', 'FontSize', 15)

bg_sub = zeros([v.Height, v.Width, 1, 100], 'logical');
for k = 1:100
    bg_sub(:, :, :, k) = abs(g_frames(:, :, :, k) - bg)>20;
end
implay(bg_sub, v.FrameRate)

% % Randomly pick 5 frames from g_frames
% dist_frame = randi(100, [1, 5]);
% 
% % Perform background subtraction with thresholds
% bg_sub1 = abs(g_frames(:, :, :, dist_frame(1)) - bg)>thres(1);
% bg_sub2 = abs(g_frames(:, :, :, dist_frame(2)) - bg)>thres(2);
% bg_sub3 = abs(g_frames(:, :, :, dist_frame(3)) - bg)>thres(3);
% bg_sub4 = abs(g_frames(:, :, :, dist_frame(4)) - bg)>thres(4);
% bg_sub5 = abs(g_frames(:, :, :, dist_frame(5)) - bg)>thres(5);

% Show the thresholded images
% figure(2), imshow(bg_sub1)
% title('Randomly Picked Frame 1', 'FontSize', 15)
% figure(3), imshow(bg_sub2)
% title('Randomly Picked Frame 2', 'FontSize', 15)
% figure(4), imshow(bg_sub3)
% title('Randomly Picked Frame 3', 'FontSize', 15)
% figure(5), imshow(bg_sub4)
% title('Randomly Picked Frame 4', 'FontSize', 15)
% figure(6), imshow(bg_sub5)
% title('Randomly Picked Frame 5', 'FontSize', 15)
end















