gumballCluster = clusterPixels('gumballs.jpg', 5);
gumballBoundaries = boundaryPixels(gumballCluster);
figure
subplot(2, 1, 1)
imagesc(gumballCluster)
subplot(2, 1, 2)
imagesc(gumballBoundaries)



snakeCluster = clusterPixels('snake.jpg', 4);
snakeBoundaries = boundaryPixels(snakeCluster);
figure
subplot(2, 1, 1)
imagesc(snakeCluster)
subplot(2, 1, 2)
imagesc(snakeBoundaries)

twinsCluster = clusterPixels('twins.jpg', 4);
twinsBoundaries = boundaryPixels(twinsCluster);
figure
subplot(2, 1, 1)
imagesc(twinsCluster)
subplot(2, 1, 2)
imagesc(twinsBoundaries)


greatSuccessCluster = clusterPixels('great_success.png', 5);
greatSuccessBoundaries = boundaryPixels(greatSuccessCluster);
figure
subplot(2, 1, 1)
imagesc(greatSuccessCluster)
subplot(2, 1, 2)
imagesc(greatSuccessBoundaries)

