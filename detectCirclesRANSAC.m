function centers = detectCirclesRANSAC(oImage, radius);
outerbound = radius * 1.02;
innerbound = radius * .98;
threshInliers = 3.14 * radius^2 * .98;
successiveFailLim = 8;
imMat = imread(oImage);
%get edges as matrix of 0's and 1's. Edges are 1's
greyMat = im2gray(imMat);
greyMat = imgaussfilt(greyMat, 4);
edgesMat = edge(greyMat);
edgesMat = uint8(edgesMat);
subplot(1, 2, 1)
imagesc(edgesMat);
%get coordinates of edge points and prep best fit storage.
[pointRows, pointColumns] = find(edgesMat);
bestFitCoords;
bestFitInliers;
pointsToRemove;
numEdgePoints = size(pointRows);
%Core loop


