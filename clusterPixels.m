function labelIm = clusterPixels(Im, k)
iterations = 10;

%cluster pixels based on RGB
imMat = imread(Im);
imRows = size(imMat, 1);
imColumns = size(imMat, 2);

%create k random centers
%each center has an RGB value
clusterCenters = randi([0, 255], k, 3);

%iterate through all the pixels in the image and assign each one to a
%cluster.

clusterMap = zeros(imRows, imColumns);


for iterationNum = 1 : iterations

    %centerRecalc stores the total R G and B values as well as the number of
    %members of that cluster so that recalculating the cluster center is quick.
    centerRecalc = zeros(k, 4);
    for rNum = 1 : imRows
        for cNum = 1:imColumns
            pixel(1, 1:3) = imMat(rNum, cNum, 1:3);
            %determine closest cluster center
            closestC = 0;
            closestCDistance = 0;
            pR = double(pixel(1));
            pG = double(pixel(2));
            pB = double(pixel(3));
            for centerNum = 1:k
                center(1, 1:3) = clusterCenters(centerNum, 1:3);
                cR = center(1);
                cG = center(2);
                cB = center(3);
                cDistance = round(sqrt((pR - cR)^2 + (pG - cG)^2 + (pB - cB)^2));
                
%                 cDistanceSqr = ((pixel(1, 1) - center(1, 1))^2 + (pixel(1, 2) - center(1, 2))^2 + (pixel(1, 3) - center(1, 3))^2);
%                 cDistance = sqrt(cDistanceSqr);
                if closestC == 0 || cDistance < closestCDistance
                    closestC = centerNum;
                    closestCDistance = cDistance;                
                end
            end
            clusterMap(rNum, cNum) = closestC;
            centerRecalc(closestC, 1:3) = centerRecalc(closestC, 1:3) + [pR, pG, pB];
            centerRecalc(closestC, 4) = centerRecalc(closestC, 4) + 1;
        end
    end

    %recalculate centers
    for cNum = 1:k
        clusterCenters(cNum, 1) = round(centerRecalc(cNum, 1) / centerRecalc(cNum, 4));
        clusterCenters(cNum, 2) = round(centerRecalc(cNum, 2) / centerRecalc(cNum, 4));
        clusterCenters(cNum, 3) = round(centerRecalc(cNum, 3) / centerRecalc(cNum, 4));
    end
    
end

labelIm = clusterMap;
%imagesc(labelIm);

