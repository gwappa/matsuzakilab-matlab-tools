function [peth, t, trigger_mask] = compute(X, triggers, opts, varargin)
    if ~isempty(varargin)
        % treat `opts` + varargin to be a list of options
        opts = ndPETH.options(opts, varargin{:});
    end

    array_dims = size(X);
    T = array_dims(1);
    if length(array_dims) > 2
        origF = array_dims(2:end);
        F = prod(origF);
        X = reshape(X, [T, F]);
    elseif array_dims(2) == 1
        origF = [];
        F = 1;
    else
        origF = array_dims(2);
        F = origF;
    end

    windows = ndPETH.windows(T, triggers, opts);
    W = opts.pretrigger + opts.posttrigger;
    N = size(windows, 1);

    peth = zeros(W, F, N);
    trigger_mask = false(size(triggers));
    t = ((1:W) - (opts.pretrigger + 1)) / opts.rate;
    for i = 1:N
        fromidx = windows.start_index(i);
        toidx = windows.end_index(i);
        peth(:, :, i) = X(fromidx:toidx, :);
        trigger_mask(windows.trigger_index(i)) = true;
    end
    if ~isempty(opts.baseline)
        peth = peth - mean(peth(baseline, :, :), 1, 'omitmissing');
    end

    % back to the original shape
    if isempty(origF)
        peth = reshape(peth, [W, N]);
    elseif length(origF) > 1
        peth = reshape(peth, [W, origF, N]);
    else
        % leave peth as-is
    end
end
