function centers = detectCirclesHT(oImage, radius)
threshPctg = .7;
imMat = imread(oImage);
%get edges as matrix of 0's and 1's. Edges are 1's
greyMat = im2gray(imMat);
greyMat = imgaussfilt(greyMat, 4);
edgesMat = edge(greyMat);
edgesMat = uint8(edgesMat);
subplot(1, 2, 1)
imagesc(edgesMat);
%get coordinates of edge points
[pointRows, pointColumns] = find(edgesMat);
paddedPointRows = pointRows + (radius);
paddedPointColumns = pointColumns + (radius);
relCoords = relCircleCoords(radius);
edgeSize = size(edgesMat);
%make padded edges matrix to accomodate circles partially out of bounds
numPaddedVotesRows = edgeSize(1) + (radius) * 2;
numPaddedVotesColumns = edgeSize(2) + (radius) * 2;
paddedVotesMat = zeros(numPaddedVotesRows, numPaddedVotesColumns, 'uint8');

%iterate through each edge point
for pointNum = 1:size(paddedPointRows)
    paddedPointR = paddedPointRows(pointNum);
    paddedPointC = paddedPointColumns(pointNum);
    paddedVoteRows = relCoords(:, 1) + paddedPointR;
    paddedVoteColumns = relCoords(:, 2) + paddedPointC;
    for voteNum = 1:size(paddedVoteRows)
        paddedVoteR = paddedVoteRows(voteNum);
        paddedVoteC = paddedVoteColumns(voteNum);
        paddedVotesMat(paddedVoteR, paddedVoteC) = paddedVotesMat(paddedVoteR, paddedVoteC) + 1;
    end 
end

%remove the padding from the padded votes matrix.
votes = paddedVotesMat(radius + 1 : numPaddedVotesRows - (radius), (radius + 1) : numPaddedVotesColumns - (radius));
subplot(1, 2, 2);
imagesc(votes);

%Get the coordinates of points above the threshold value.
highestVote = max(votes, [], 'all');
threshold = round(highestVote * threshPctg);
[centerRows, centerColumns] = find(votes > threshold);
centers = [centerRows, centerColumns];
numCenters = size(centerRows);
%draw circles of given radius around centers
drawnCircles = imMat;
for cNum = 1 : numCenters(1)
    centerR = centerRows(cNum);
    centerC = centerColumns(cNum);
    circleRows = relCoords(:, 1) + centerR;
    circleColumns = relCoords(:, 2) + centerC;
    numCirclePoints = size(circleRows);
    for pointNum = 1 : numCirclePoints
        pointR = circleRows(pointNum);
        pointC = circleColumns(pointNum);
        drawnCircles(pointR, pointC, :) = [255, 0, 0];
    end
end
imwrite(drawnCircles, 'drawnCircles.jpg');


