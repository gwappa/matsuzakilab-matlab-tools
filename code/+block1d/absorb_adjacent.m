function events_out = absorb_adjacent(events_in, fn)
    % events_out = block1d.ABSORB_ADJACENT(events_in, fn)
    %
    % absorbs the 'nxt' block into the 'prv' block when
    % 'fn(prv, nxt)' evaluates to true.
    %
    % @version 1.0.0
    % @author gwappa
    % @license MIT
    %
    
    if size(events_in, 1) == 0
        events_out = events_in;
        return
    end

    events_out = events_in(1, :);
    for i = 2:size(events_in, 1)
        nxt = events_in(i,:);
        if fn(events_out(end, :), nxt)
            events_out(end, :).stop = nxt.stop;
        else
            events_out = cat(1, events_out, nxt);
        end
    end
end
