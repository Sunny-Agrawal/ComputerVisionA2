function boundaryIm = boundaryPixels(labelIm)
boundaryIm = edge(labelIm);
[pointRows, pointColumns] = find(boundaryIm);
for p = 1 : size(pointRows)
    boundaryIm(pointRows(p), pointColumns(p)) = labelIm(pointRows(p), pointColumns(p));
end
