function values = parse_data_line(line, sep, num, onset, offset)
    % for internal use: parses a line of floating-point numbers separated by whitespaces
    if ~isempty(sep)
        items = split(line, sep);
    else
        items = split(line); % use whitespaces by default
    end
    values = str2double(items(onset:offset));
end
