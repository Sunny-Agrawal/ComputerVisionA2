%return an array of coordinates of all edge points of a circle relative to
%a circle with center (0,0) and a given radius
function coords = relCircleCoords(radius)
%Exluding the rightmost and leftmost column, each column in the diameter of the
%circle will have 2 points.
coords = zeros(2*2*radius - 2, 2);
%place rightmost, leftmost, top and bottom coordinates.
coords(1, 2) = -radius;
coords(2, 2) = radius;
coords(3, 1) = radius;
coords(4, 1) = -radius;
point = 5;
for columnDistance = 1 : radius - 1
    %for each column in between, use pythagorean theorem to find the row values
    %of the two points.
    rowDistance = sqrt(radius^2 - columnDistance^2);
    %fill in four points based on row and column distances
    coords(point, 1:2) = round([rowDistance, columnDistance]);
    point = point + 1;
    coords(point, 1:2) = round([-rowDistance, columnDistance]);
    point = point + 1;
    coords(point, 1:2) = round([rowDistance, -columnDistance]);
    point = point + 1;
    coords(point, 1:2) = round([-rowDistance, -columnDistance]);
    point = point + 1;  
end

