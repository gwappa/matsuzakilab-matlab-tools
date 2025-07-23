function [data, header_data] = read_dlc(dlcpath, report_interval, read_block_size)
    % [data, header_data] = csvio.READ_DLC(lvmpath[, report_interval=10000[, read_block_size=500000]])
    %
    % reads the contents of the `lvmpath` and returns as a table.
    % the contents of the header will be stored in the `header_data`
    % output variable.
    %
    % - if `report_interval` (in samples/rows) is non-empty,
    %   the progress of the procedure is printed out on the console.
    %
    % - to speed up the data-input process, the data array is allocated
    %   in blocks of samples. One can specify the size of each block by
    %   setting the `read_block_size` variable (in samples).
    %
    %   Larger block sizes will results in efficient data reads, at the
    %   expense of the increased risk of 'discarding' some samples at the
    %   end.
    %
    REPORT_INTERVAL_DEFAULT = 1000;
    BLOCK_SIZE_DEFAULT = 500000;
    SEP = ',';

    if (nargin < 2)
        report_interval = REPORT_INTERVAL_DEFAULT;
    end
    if (nargin < 3) || isempty(read_block_size)
        read_block_size = BLOCK_SIZE_DEFAULT;
    end
    src = fopen(dlcpath);
    defer = onCleanup(@() fclose(src));

    header_data = read_header_(src, SEP);

    % initialize columns
    columns = strings(1, length(header_data.labels) * 3);
    for i = 1:length(header_data.labels)
        label = header_data.labels(i);
        base = (i - 1) * 3;
        columns(base + 1) = sprintf("%s_x", label); 
        columns(base + 2) = sprintf("%s_y", label); 
        columns(base + 3) = sprintf("%s_p", label); 
    end

    % set up data read
    if header_data.has_index
        read_onset = 2;
    else
        read_onset = 1;
    end
    read_offset = read_onset + length(columns) - 1;

    % read data block
    data = csvio.parse_data_block(
        sec, ...
        SEP, ...
        length(columns), ...
        read_onset, ...
        read_offset, ...
        read_block_size, ...
        report_interval ...
    )
    data = array2table(data, "VariableNames", columns);
end

function header_data = read_header_(src, sep)
    scorer_line = fgetl(src);
    scorer_row = split(string(scorer_line), sep);
    labels_line = fgetl(src);
    labels_row = split(string(labels_line), sep);
    ~ = fgetl(src);  % discard the coords line (for now: we are dealing with 2D)

    has_index = (scorer_row(1) == "scorer");
    if has_index
        scorer_row = scorer_row(2:end);
        labels_row = labels_row(2:end);
    end
    header_data = struct;
    header_data.has_index = has_index;
    header_data.scorer = scorer_row(1);
    header_data.labels = labels_row(1:3:end);
end
