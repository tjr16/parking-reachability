function plotRectangle(rec, single)
% param:
% rec - a cell of 4-element lists [xmin, ymin, xmax, ymax]
% single (optional) - if true, only one 4 X 1 double vector
    
    if nargin < 2
        single = false;
    end

    if single
        x = rec;
        w = x(3) - x(1);
        h = x(4) - x(2);
        x(3) = w;
        x(4) = h;
        rectangle('Position', x, 'EdgeColor', [rand(1,3), 0.9], 'LineWidth', 3, 'FaceColor',[0.4660, 0.6740, 0.1880]); 
        % [x y w h]; EdgeColor: rgb, alpha
    else
        for i = 1:length(rec)
            x = cell2mat(rec(i));
            w = x(3) - x(1);
            h = x(4) - x(2);
            x(3) = w;
            x(4) = h;
            rectangle('Position', x, 'EdgeColor', [0.25, 0.25, 0.25], 'LineWidth', 1.5); % [x y w h] 
        end
    end
%     axis([0 10 0 10]);
end

