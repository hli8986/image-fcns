function Inew = myCTSegmentation(I, b)
% This function takes input of a gracyscale image with an output of 
% pseudocolored segmented tisse image. The tissues that could be recognized 
% are liver, two kidneys, spine column and spleen in blue, organe, yellow 
% and red, respectively.
% Created by Hao Li haoli1@ufl.edu

% Input:
% I: grayscale image

% Output:
% Inew: pseudocolor image

if ~exist('b', 'var')
     b = 0;
end

%% Thresholding & Region correction

% Reduce noise with gaussian filter
Ibur = imgaussfilt(I, 2, 'FilterSize', 3);

% Apply adaptive threshold using local mean
tau = adaptthresh(Ibur, 0.59)*256;
I1 = Ibur > tau;

% imshow(I1)
% title('Thresholded image')

% Set structuring element for binray operations
se1 = strel('disk', 5, 0);
se2 = strel('disk', 3, 0);

% Binary poerations
i4 = imerode(I1, se1);

stats = regionprops('table', i4, 'Area', 'Centroid', 'BoundingBox');
area = stats.Area;
i555 = bitxor(bwareaopen(i4, max(area)-1), bwareaopen(i4, max(area)+1));

ia = bitxor(I1, i555);
ib = imerode(ia, se2);
ic = bwareaopen(ib, 80);
id = imdilate(ic, se2);
ie = imfill(id, 'holes');

%% Connected Component Labeling

% Initialize label and equivalence table
L = zeros(size(ie));
next_label = 1;
equiv = 1:532;

if b
    for i = 2:(size(ie,1)-1)
        for j = 2:(size(ie,2)-1)
            if ie(i, j) ~= 0
                v = ie(i, j);
                % Compare 4 neighbors
                if v == ie(i-1, j) && v == ie(i, j-1) ...
                        && v == ie(i+1, j) && v== ie(i, j+1)
                    L(i, j) = L(i-1, j);
                    L(i-1, j) = L(i, j-1);
                    a = getlabel(L(i-1, j), equiv);
                    b = getlabel(L(i, j-1), equiv);
                    if a > b
                        equiv(a) = b;
                    else
                        equiv(b) = a;
                    end
                elseif v == ie(i-1, j)
                    L(i, j) = L(i-1, j);
                elseif v == ie(i, j-1)
                    L(i, j) = L(i, j-1);
                elseif v == ie(i, j+1)
                    L(i, j) = L(i, j+1);
                elseif v == ie(i+1, j)
                    L(i, j) = L(i+1, j);
                else
                    % Increment label if none is matching
                    L(i, j) = next_label;
                    next_label = next_label + 1;
                end
            end
        end
    end
    
    % imshow(uint8(L*256/next_label))
    % title('Labeled image')
    
    % Traverse label to minimize the number of groups
    for i = 1:size(L,1)
        for j = 1:size(L,2)
            if L(i, j) ~= 0
                L(i, j) = getlabel(L(i, j), equiv);
            end
        end
    end
    
    % Extract region properties
    stats = regionprops('table', L, 'Area', 'Centroid', 'Orientation', ...
        'Eccentricity', 'ConvexHull', 'Circularity');
    
else
    % Label the image
    l12 = bwlabel(ie, 4);
    
    % imshow(l12)
    % title('Labeled image')
    
    % Extract region properties
    stats = regionprops('table', l12, 'Area', 'Centroid', 'Orientation', ...
        'Eccentricity', 'ConvexHull', 'Circularity');
end

cent = stats.Centroid;
% eccen = stats.Eccentricity;
% area = stats.Area;
% orie = stats.Orientation;
% circ = stats.Circularity;

% Determine tissues with centroid information
% This may not be robust but it works for current inputs
[liver,~] = find(cent(:,2)>150 & cent(:,2)<380 & cent(:,1)>100 ...
    & cent(:,1)<140);

[kid1,~] = find(cent(:,2)>150 & cent(:,2)<380 & cent(:,1)>130 ...
    & cent(:,1)<180);

[spine,~] = find(cent(:,2)>300 & cent(:,2)<380 & cent(:,1)>190 ...
    & cent(:,1)<300);

[kid2,~] = find(cent(:,2)>250 & cent(:,2)<380 & cent(:,1)>300 ...
    & cent(:,1)<400);

[spleen,~] = find(cent(:,2)>230 & cent(:,2)<380 & cent(:,1)>400 ...
    & cent(:,1)<512);

% imshow(ie)
% hold on
% plot(organs(:,1), organs(:,2),'b*')
% hold off

% Separate each tissue from the labeled image
liv = ismember(l12, liver);
ki1 = ismember(l12, kid1);
spi = ismember(l12, spine);
ki2 = ismember(l12, kid2);
spl = ismember(l12, spleen);

% blue      (0, 0, 255)
% orange    (255, 69, 0)
% yellow    (255, 255, 0)
% red       (255, 0, 0)

% Paint the tissue
I13 = I + uint8(liv)*255;
I21 = I + uint8(ki1)*255;
I22 = I + uint8(ki1)*69;
I31 = I + uint8(spi)*255;
I32 = I + uint8(spi)*169;
I41 = I + uint8(ki2)*255;
I42 = I + uint8(ki2)*69;
I51 = I + uint8(spl)*255;

% Construct red and green channel
I11 = bitor(bitor(bitor(I21, I31), I41), I51);
I12 = bitor(bitor(I22, I32), I42);

% Construct pseudocolor image
Inew = cat(3, I11, I12, I13);
imshow(Inew)
title('Colored output image')
end


