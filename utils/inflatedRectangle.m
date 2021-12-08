function newRec = inflatedRectangle(grid, rec, r)
% rec - a cell of 4-element lists [xmin, ymin, xmax, ymax]  
    newRec = shapeRectangleByCorners(...
        grid, [rec(1)-r; rec(2)-r; -inf; -inf], [rec(3)+r; rec(4)+r; inf; inf]);
end
