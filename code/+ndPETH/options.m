function opts = options(varargin)
    % opts = ndPETH.OPTIONS(
    %   'rate', ...,
    %   'pretrigger', ...,
    %   'pretrigger_sec', ...,
    %   'posttrigger_sec', ...,
    %   'posttrigger', ...,
    %   'baseline', []
    % )
    %
    % - rate (in Hz): by default, the value from
    %   `localsettings.lvm_sampling_rate` is used.
    %
    % - pretrigger (in samples): the number of samples to be extracted
    %   before each trigger (exclusive). If this value is specified,
    %   the value in `pretrigger_sec` is ignored.
    %   by default, 0 will be used (i.e. no pre-trigger samples).
    %
    % - posttrigger (in samples): the number of samples to be extracted
    %   after each trigger (inclusive). If this value is specified,
    %   the value in `posttrigger_sec` is ignored.
    %
    % - pretrigger_sec (in seconds):
    % - posttrigger_sec (in seconds):
    %   same as `pretrigger` and `posttrigger`. Internally computes
    %   `pretrigger` or `posttrigger` values by multiplying with `rate`.
    %
    % - baseline (an array of indices): the indices to be used as the
    %   baseline-subtraction window, with respect to each extracted
    %   peri-trigger window.
    %   by default, an empty array [] is used (i.e. no baseline subtraction).
    %
    opts = struct(varargin{:});
    if ~isfield(opts, 'rate')
        opts.rate = localsettings.lvm_sampling_rate;
    end
    if ~isfield(opts, 'pretrigger')
        if ~isfield(opts, 'pretrigger_sec')
            opts.pretrigger_sec = 0;
        end
        opts.pretrigger = round(opts.pretrigger_sec * opts.rate);
    end
    if ~isfield(opts, 'posttrigger')
        if ~isfield(opts, 'posttrigger_sec')
            error("either of 'posttrigger' or 'posttrigger_sec' must be specified");
        end
        opts.posttrigger = round(opts.posttrigger_sec * opts.rate);
    end
    if ~isfield(opts, 'baseline')
        opts.baseline = [];
    end
end
