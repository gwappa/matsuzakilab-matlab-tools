function h = fill_between_xlines(xmin, xmax, varargin)
    opts = struct(varargin{:});
    if isfield(opts, 'color')
        color = opts.color;
    else
        color = 'k';
    end
    if isfield(opts, 'alpha')
        alpha = opts.alpha;
    else
        alpha = 0.15;
    end
    if isfield(opts, 'ylim')
        yrng = opts.ylim;
    else
        yrng = get(gca, 'YLim');
    end
    h = plotting.fill_between([xmin, xmax], [yrng(1) yrng(1)], [yrng(2) yrng(2)], ...
        struct('color', color, 'alpha', alpha));
end
