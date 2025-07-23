function data = parse_data_block(src, sep, num_columns, read_onset, read_offset, block_size, report_interval)
    if nargin < 2
        sep = [];
    end
    if (nargin < 4) || isempty(read_onset)
        read_onset = 1;
    end
    if (nargin < 5) || isempty(read_offset)
        read_offset = read_onset + num_columns - 1;
    end
    if (nargin < 6) || isempty(block_size)
        block_size = csvio.default_block_size;
    end
    if nargin < 7
        report_interval = csvio.default_report_interval;
    end

    data = zeros(block_size, num_columns);
    if ~isempty(report_interval)
        report_interval = round(abs(report_interval));
        prog = csvio.report_progress('reading...', '');
        report_offset = 0;
        start = tic;
    end

    rowidx = 1;
    while ~feof(src)
        line = fgetl(src);  % _no_ strip(), as it can affect the result of split() later
        if isempty(strip(line))
            break
        end
        data(rowidx, :) = csvio.parse_data_line(line, sep, num_columns, read_onset, read_offset);
        rowidx = rowidx + 1;
        if ~isempty(report_interval)
            report_offset = report_offset + 1;
            if report_offset == report_interval
                prog = csvio.report_progress(sprintf('reading : %d rows...', rowidx - 1), prog);
                report_offset = 0;
            end
        end
        if rowidx > size(data, 1)
            data = cat(1, data, zeros(block_size, num_columns));
        end
    end
    num_rows_read = rowidx - 1;
    csvio.report_progress(sprintf("read: %d rows: ", num_rows_read), prog);
    toc(start);
    data((num_rows_read + 1):end, :) = [];
end
