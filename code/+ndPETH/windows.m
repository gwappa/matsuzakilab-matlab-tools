function window_specs = windows(T, triggers, opts)
    % [window_specs, trigger_mask] = ndPETH.WINDOWS(T, triggers, opts)
    %
    % determines the start/end indices of the peri-trigger windows
    % used for `ndPETH.COMPUTE`.
    %
    % Inputs
    % ------
    %
    % - T (positive integer): the size of the array.
    % - triggers (array of indices): the trigger indices.
    % - opts (struct): in the same format as `ndPETH.OPTIONS` returns.
    %
    % Outputs
    % -------
    %
    % - window_specs (table): the start/stop indices + trigger indices
    %
    triggers = reshape(triggers, [], 1);
    window_specs = table;
    window_specs.start_index = triggers - opts.pretrigger;
    window_specs.end_index = triggers + opts.posttrigger - 1;
    window_specs.trigger_index = (1:length(triggers)).';
    valid = logical((window_specs.start_index > 0) .* (window_specs.end_index <= T));
    window_specs(~valid, :) = [];
end
