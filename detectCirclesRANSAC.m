function centers = detectCirclesRANSAC(oImage, radius);
outerbound = radius * 1.02;
innerbound = radius * .98;
threshInliers = 3.14 * radius^2 * .98;
successiveFailLim = 8;
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
bestFitCenter;
bestFitNumInliers;
curCenter;
curNumInliers;
bfPointsToRemove = zeros(size(pointRows), 2);
curPointsToRemove = zeros(size(pointRows), 2);
bfNumPointsToRemove = 0;
numPointsToRemove = 0;
successiveFails=0;
allFound = false;
numEdgePoints = size(pointRows);
%Core loop
while !allFound
    %get a random pixel to try as a center.
    centerR = randi(imSize(1), 1, 1);
    centerC = randi(imSize(2), 2, 2);
    %find inliers
    for pointNum = 1 : size(pointRows)
        %get edge point
        pointR = pointRows(pointNum);
        pointC = pointColumns(pointNum);
        %find distance from center
        distance = sqrt((pointR - centerR)^2 + (pointC - centerC)^2);
        %compare to bounds.
        if distance <= outerbound
            numPointsToRemove = numPointsToRemove + 1;
            curpointsToRemove(numPointsToRemove, 1:2) = [pointR, pointC];
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
                %best fit is a circle. Store its center and remove all
                %points in it from edges.
            else
                allFound = true;
            end
        end
            
    end
end



