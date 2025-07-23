function prog = report_progress(msg, prog)
    % intended for the internal use of reporting the progress on the
    % standard output
    %
    % Arguments
    % ---------
    % - msg: the new line of message to show
    % - prog: the (supposedly) current message being shown
    %
    % Returns
    % -------
    % - prog: the updated line of message being shown
    %
    if (nargin < 2) || isempty(prog)
        prog = '';
    end
    dels = repmat('\b', [1, length(char(prog))]);
    fprintf(dels);
    fprintf(msg);
    prog = msg;
end
