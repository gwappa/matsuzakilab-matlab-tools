function events = detect_pulses(flags)
    % events = block1d.DETECT_PULSES(flags)
    %
    % extract events (i.e. those where `flags` are true) as a table (start/stop).
    %
    events = block1d.compute(flags);
    events(events.value == 0, :) = [];
    events.value = [];
end
