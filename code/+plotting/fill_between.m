function h = fill_between(x, y1, y2, varargin)
    opts = struct(varargin{:});
    if isfield(opts, 'edgecolor')
        edgecolor = opts.edgecolor;
    else
        edgecolor = 'none';
    end
    if isfield(opts, 'color')
        color = opts.color;
    else
        color = [0.5, 0.5, 0.5];
    end
    if isfield(opts, 'alpha')
        alpha = opts.alpha;
    else
        alpha = 0.15;
    end
    
    x  = reshape(x, 1, []);
    y1 = reshape(y1, 1, []);
    y2 = reshape(y2, 1, []);

    siz = length(x);
    if length(y1) == 1
        y1 = repmat(y1, [1 siz]);
    end
    if length(y2) == 1
        y2 = repmat(y2, [1 siz]);
    end
    
    h = fill([x, fliplr(x)], [y1, fliplr(y2)], color, ...
             'EdgeColor', edgecolor, 'FaceAlpha', alpha); 
end
