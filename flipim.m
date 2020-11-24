function i = flipim(I)

% Show original image
figure (1)
imshow(I)

% Label the quadrants based on the original image
quad1 = I(1:end/2, 1:end/2, :); % Left up quadrant
quad2 = I(1:end/2, end/2+1:end, :); % Right up quadrant
quad3 = I(end/2+1:end, 1:end/2, :); % Left bottom quadrant
quad4 = I(end/2+1:end, end/2+1:end, :); % Right bottom quadrant

% Rearrange the position
i = [quad4 quad3; quad2 quad1];

% Show revised image
figure (2)
imshow(i)

return
end