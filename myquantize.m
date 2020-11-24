function q = myquantize(I, quant_num)
% Hao Li
% haoli1

% Get the divisor for image
div = 256/quant_num;

% Calculate each step of the corresponding intensity value
group = 255/(quant_num - 1);

% Obtain quantized image with quantized number
q = I/div * group;

% Sow the quantized image
figure
imshow(q)
end

% The code works based on the figure 3.16 from the textbook.
% The desired quantized number indicates number of colors in the image.
% These colors could be seen as steps of intensity value an image has.
% Thus for each quantized number, there should be a number of pixels on 
% each step. This is the divisor. Then we need to know the range of each
% step, which is 255 divided by the quantized number subtracting one. The
% reason of subtracting one is the due to the top step(255) is occupied.
% Then using the image matrix divides the divisor will give corresponding 
% step each pixel at. Multiplying the group provides the pixel its
% corresponding intensity value.
