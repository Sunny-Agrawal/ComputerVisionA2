function centers = detectCircles(oImage, radius)

imageMat = imread(oImage);

%get edges as matrix of 0's and 1's. Edges are 1's
edgesMat = edge(imageMat);
edgeSize = size(edgesMat);
%make padded edges matrix to accomodate circles partially out of bounds
paddedEdgesRows = edgeSize(1) + (radius - 1) * 2;
paddedEdgesColumns = edgeSize(2) + (radius - 1) * 2;
paddedEdges = ones(paddedEdgesRows, paddedEdgesColumns);
paddedEdges(radius: paddedEdgesRows - radius, radius : paddedEdgesColumns - radius) = edgesMat;
%make a matrix of votes-- will be the same size as the image
votes = zeros(edgeSize(1), edgeSize(2));
%treat each pixel in the image as the center of a circle and calculate the
%probability that a circle exists there.
for row = 1:edgeSize(1)
    paddedEdgesRow = row + radius;
    for column = 1:edgeSize(2)
        paddedEdgesColumn = column + radius;
        
    end
end
