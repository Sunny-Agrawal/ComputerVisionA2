function centers = detectCirclesRANSAC(oImage, radius);
numTries = 0;
tries = 0;
centers = [0, 0];
numCenters = 0;
outerbound = radius + 2;
innerbound = radius - 2;
threshInliers = 3.14 * radius * 2 * .4;
successiveFailLim = 1000;
imMat = imread(oImage);
imSize = size(imMat);
%get edges as matrix of 0's and 1's. Edges are 1's
greyMat = im2gray(imMat);
%greyMat = imgaussfilt(greyMat, 4);
edgesMat = edge(greyMat);
edgesMat = uint8(edgesMat);
%subplot(1, 2, 1)
imagesc(edgesMat);
%get coordinates of edge points and prep best fit storage.
[pointRows, pointColumns] = find(edgesMat);

%sample squares of the image that are a certain number of radii in length
%and height. Squares will overlap eachother 50%
sampleDimension = radius * 4;
sampleIncrement = sampleDimension/2;

sampleTopBound = 0;
sampleBottomBound = sampleDimension;
%Core loop


%loops for sampling

samplesComplete = false;
firstSamplesIteration = true;
while samplesComplete == false
   if firstSamplesIteration
       firstSamplesIteration = false;
   else
       sampleTopBound = sampleTopBound + sampleIncrement;
       sampleBottomBound = sampleBottomBound + sampleIncrement;
   end
   if sampleBottomBound >= imSize(1)
       sampleBottomBound = imSize(1);
       samplesComplete = true;
   end
   sampleLeftBound = 0;
   sampleRightBound = sampleDimension;
   sampleRowComplete = false;
   firstRowIteration = true;
    while sampleRowComplete == false
        if firstRowIteration
            firstRowIteration = false;
        else
            sampleLeftBound = sampleLeftBound + sampleIncrement;
            sampleRightBound = sampleRightBound + sampleIncrement;
        end
        if sampleRightBound >= imSize(2)
            sampleRightBound = imSize(2);
            sampleRowComplete = true;
        end
        
        
        %RUN RANSAC ON THE SAMPLE--------------------
        
            
        bestFitCenter = [0,0];
        bestFitNumInliers = 0;
        bfPointsToRemove = zeros(size(pointRows));
        bfNumPointsToRemove = 0;
        successiveFails=0;
        allFound = false;
        while allFound == false
            %get a random pixel to try as a center.
            centerR = randi([sampleTopBound, sampleBottomBound], 1, 1);
            centerC = randi([sampleLeftBound, sampleRightBound], 1, 1);
            curCenter = [centerR, centerC];
            curNumInliers = 0;
            curNumPointsToRemove = 0;
            curPointsToRemove = zeros(size(pointRows));
            %find inliers
            for pointNum = 1 : size(pointRows)
                %get edge point
                pointR = pointRows(pointNum);
                pointC = pointColumns(pointNum);
                %find distance from center
                distance = sqrt((pointR - centerR)^2 + (pointC - centerC)^2);
                %compare to bounds.
                if distance <= outerbound
                    curNumPointsToRemove = curNumPointsToRemove + 1;
                    curPointsToRemove(curNumPointsToRemove) = pointNum;
                    if distance >= innerbound
                        curNumInliers = curNumInliers + 1;
                    end
                end
            end
            numTries = numTries + 1;
            tries(numTries) = bestFitNumInliers;
            if curNumInliers > bestFitNumInliers
                bestFitNumInliers = curNumInliers;
                bestFitCenter = curCenter;
                bfPointsToRemove = curPointsToRemove;
                bfNumPointsToRemove = curNumPointsToRemove;
                successiveFails = 0;
            else
                successiveFails = successiveFails + 1;
                if successiveFails >= successiveFailLim
                    if bestFitNumInliers >= threshInliers
                        %best fit is a circle. Store its center
                        numCenters = numCenters + 1;
                        centers(numCenters, 1:2) = bestFitCenter(1:2);
                        %remove all points in this best fit from pointRows,
                        %pointColumns
                        numRemoved = 0;
                        for p = 1 : bfNumPointsToRemove
                            rawIndex = bfPointsToRemove(p);
                            pointIndex = bfPointsToRemove(p) - p + 1;
                            if pointIndex > size(pointRows)
                                pointIndex
                            end
                            pointRows(pointIndex) = [];
                            pointColumns(pointIndex) = [];
                            numRemoved = numRemoved + 1;
                        end
                        bestFitNumInliers = 0;
                    else
                        allFound = true;
                    end
                end
                
            end
            
            
        end
        %RANSAC LOOP END---------------------------------     
        
    end  
end

plot(tries);

% sizeCenters = size(centers);
% radii = zeros(sizeCenters(1), 1);
% radii = radii + radius;
% viscircles(centers, radii);
% relCoords = relCircleCoords(radius);
centerRows = centers(:, 1);
centerColumns = centers(:, 2);
numCenters = size(centerRows, 1);
%draw circles of given radius around centers
% drawnCircles = imMat;
% for cNum = 1 : numCenters(1)
%     centerR = centerRows(cNum);
%     centerC = centerColumns(cNum);
%     circleRows = relCoords(:, 1) + centerR;
%     circleColumns = relCoords(:, 2) + centerC;
%     numCirclePoints = size(circleRows);
%     for pointNum = 1 : numCirclePoints
%         pointR = circleRows(pointNum);
%         pointC = circleColumns(pointNum);
%         drawnCircles(pointR, pointC, :) = [255, 0, 0];
%     end
% end
% imwrite(drawnCircles, 'drawnCirclesRANSAC.jpg');
imshow(oImage);
xyCenters = zeros(numCenters, 2);
xyCenters(:, 1) = centerColumns(:, 1);
xyCenters(:, 2) = centerRows(:, 1);
radii = zeros(1, numCenters) + radius;
viscircles(xyCenters, radii); 
title('soccerballs.jpg RANSAC radius 60');





