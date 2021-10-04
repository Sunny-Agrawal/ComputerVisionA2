function centers = detectCirclesRANSAC(oImage, radius);
centers = [0, 0];
numCenters = 0;
outerbound = radius * 1.02;
innerbound = radius * .98;
threshInliers = 3.14 * radius * 2 * .25;
successiveFailLim = 10000;
imMat = imread(oImage);
imSize = size(imMat);
%get edges as matrix of 0's and 1's. Edges are 1's
greyMat = im2gray(imMat);
greyMat = imgaussfilt(greyMat, 4);
edgesMat = edge(greyMat);
edgesMat = uint8(edgesMat);
subplot(1, 2, 1)
imagesc(edgesMat);
%get coordinates of edge points and prep best fit storage.
[pointRows, pointColumns] = find(edgesMat);
bestFitCenter = [0,0];
bestFitNumInliers = 0;
bfPointsToRemove = zeros(size(pointRows));
bfNumPointsToRemove = 0;
successiveFails=0;
allFound = false;
%Core loop
while allFound == false
    %get a random pixel to try as a center.
    centerR = randi(imSize(1), 1, 1);
    centerC = randi(imSize(2), 1, 1);
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
                    if pointIndex > size(pointRows);
                        pointIndex
                    end
                    pointRows(pointIndex) = [];
                    pointColumns(pointIndex) = [];
                    numRemoved = numRemoved + 1;
                end    
            else
                allFound = true;
            end
        end
            
    end
end
viscircles(centers, radius);



