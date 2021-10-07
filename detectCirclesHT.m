function centers = detectCirclesHT(oImage, radius)
threshPctg = .35;
imMat = imread(oImage);
%get edges as matrix of 0's and 1's. Edges are 1's
greyMat = im2gray(imMat);
% greyMat = imgaussfilt(greyMat, 4);
edgesMat = edge(greyMat);
edgesMat = uint8(edgesMat);
% subplot(1, 2, 1)
% imagesc(edgesMat);
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
% subplot(1, 2, 2);
imagesc(votes);
title('soccerballs Hough Space Accumulator')

%Get the coordinates of points above the threshold value.
highestVote = max(votes, [], 'all');
threshold = round(highestVote * threshPctg);
[centerRows, centerColumns] = find(votes > threshold);
%remove centers that likely pertain to textures. These will likely be very
%close to other centers.
centers = 0;
centerRowsSize = size(centerRows);
numToVet = centerRowsSize(1);
for i = 1 : size(centerRows)
    c = [centerRows(i), centerColumns(i)];
    centerVotes = votes(c(1), c(2));
    isOkay = true;
    stillVetting = true;
    vetI = 1;
    while stillVetting & vetI <= numToVet
        if vetI == i
        else
            vetC = [centerRows(vetI), centerColumns(vetI)];
            vetCVotes = votes(vetC(1), vetC(2));
            distance = sqrt((vetC(1) - c(1))^2 + (vetC(2) - c(2))^2);
            if distance < (2 * radius) & centerVotes < vetCVotes
                stillVetting = false;
                isOkay = false;
            end
        end
        vetI = vetI + 1;
    end
    if isOkay
        centers(end + 1, 1:2) = c(1, 1:2);
    end
end
centers = centers(2:end, 1:2);
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
imshow(oImage);
xyCenters = zeros(numCenters, 2);
xyCenters(:, 1) = centerColumns(:, 1);
xyCenters(:, 2) = centerRows(:, 1);
radii = zeros(1, numCenters) + radius;
viscircles(xyCenters, radii); 
title('soccerballs.jpg HT radius 60');


