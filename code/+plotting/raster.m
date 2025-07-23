function raster(x, y1, y2, varargin)
    % plotting.RASTER(x, y1, y2, ...)
    %
    % the variable input terms (...) will be passed directly
    % to the `plot()` function, so that one can specify
    % the format of the line(s) to be drawn.
    %
    if (nargin < 2) || isempty(y1)
        y1 = 1;
    end
    if numel(y1) > 1
        y1 = y1(1);
    end

    if (nargin < 3) || isempty(y2)
        y2 = 0;
    end
    if numel(y2) > 1
        y2 = y2(1);
    end

    x = reshape(x, 1, []);
    xcoords = repmat(x, [3, 1]);
    xcoords(3, :) = NaN;
    ycoords = zeros(size(xcoords));
    ycoords(1, :) = y1;
    ycoords(2, :) = y2;
    ycoords(3, :) = NaN;

    plot(reshape(xcoords, [], 1), reshape(ycoords, [], 1), varargin{:});
end
