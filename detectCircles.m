function centers = detectCircles(oImage, radius)
threshPctg = .9;
imMat = imread(oImage);
greyMat = im2gray(imMat);
%get edges as matrix of 0's and 1's. Edges are 1's
edgesMat = edge(greyMat);
%get coordinates of edge points
[pointRows, pointColumns] = find(edgesMat);
paddedPointRows = pointRows + (radius);
paddedPointColumns = pointColumns + (radius);
relCoords = relCircleCoords(radius);
edgeSize = size(edgesMat);
%make padded edges matrix to accomodate circles partially out of bounds
numPaddedVotesRows = edgeSize(1) + (radius - 1) * 2;
numPaddedVotesColumns = edgeSize(2) + (radius - 1) * 2;
paddedVotesMat = zeros(numPaddedVotesRows, numPaddedVotesColumns);

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
votes = paddedVotesMat(radius : numPaddedVotesRows - radius, radius : numPaddedVotesColumns - radius);
imwrite(votes, 'votes.jpg');
