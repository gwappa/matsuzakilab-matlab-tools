function [data, header_data] = read_lvm(lvmpath, report_interval, read_block_size)
    % [data, header_data] = csvio.READ_LVM(lvmpath[, report_interval=10000[, read_block_size=500000]])
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
    REPORT_INTERVAL_DEFAULT = 10000;
    BLOCK_SIZE_DEFAULT = 500000;

    if (nargin < 2)
        report_interval = REPORT_INTERVAL_DEFAULT;
    end
    if (nargin < 3) || isempty(read_block_size)
        read_block_size = BLOCK_SIZE_DEFAULT;
    end
    src = fopen(lvmpath);
    defer = onCleanup(@() fclose(src));

    header_data = read_file_header_(src, lvmpath);
    header_data.Table = read_table_header_(src);
    if isempty(header_data.Table)
        num_channels = [];
    else
        num_channels = header_data.Table.Channels;
    end

    data = read_lvm_data_(src, num_channels, report_interval, read_block_size);
    if ~isempty(read_block_size)
        fprintf("done reading from: %s\n", lvmpath);
    end
end

function read_empty_lines_(fid)
    offset = ftell(fid);
    while ~feof(fid)
        line = fgetl(fid);
        if ~isempty(strip(line))
            fseek(fid, offset, 'bof');
            return
        end
        offset = ftell(fid);
    end
end

function header = read_file_header_(src, filepath)
    LVM_HEADER = 'LabVIEW Measurement';
    HEADER_END = '***End_of_Header***';

    fseek(src, 0, 'bof');

    line = fgetl(src);
    if ~strcmp(strip(line), LVM_HEADER)
        error('does not seem to be an LVM file: %s', filepath);
    end

    header = struct;
    while true
        line = strip(fgetl(src));
        if strcmp(line, HEADER_END)
            return
        end
        [name, value] = parse_file_header_line_(line);
        header.(name) = value;
    end
end

function [name, value] = parse_file_header_line_(line)
    items = split(line);
    if length(items) ~= 2
        error("failed to parse line: '%s'", line);
    end
    name = items{1};
    value = items{2};  % TODO: eval for specific data types?
end

function header = read_table_header_(src)
    HEADER_END = '***End_of_Header***';

    read_empty_lines_(src);
    line = strip(fgetl(src));
    if ~startsWith(line, 'Channels')
        header = [];
        return
    end
    chan_spec = split(line);
    num_channels = str2double(chan_spec{2});
    if isnan(num_channels)
        error("failed to read the number of channels from line: '%s'", line);
    end
    header = struct;
    header.Channels = num_channels;

    while true
        line = strip(fgetl(src));
        if strcmp(line, HEADER_END)
            return
        end
        [name, values] = parse_table_header_line_(line, num_channels);
        header.(name) = values;
    end
end

function [name, values] = parse_table_header_line_(line, num_channels)
    items = split(line);
    if length(items) ~= (num_channels + 1)
        error("failed to parse line: '%s'", line);
    end
    name = items{1};
    values = items(2:end);  % TODO: eval for specific data types?
end

function data = read_lvm_data_(src, num_channels, report_interval, block_size)
    OMIT_XVALUE = 2;

    read_empty_lines_(src);
    line = strip(fgetl(src));
    if ~startsWith(line, 'X_Value')
        error("unexpected start of the LVM data table: '%s'", line);
    end
    names_base = split(replace(line, ' ', '_'));
    if isempty(num_channels)
        num_channels = length(names_base) - 2;  % remove 'X_Value' and 'Comment'
    else
        if length(names_base) ~= (num_channels + 2)
            error("expected %d columns, but got %d in the LVM data table: '%s'", ...
                num_channels + 2, length(names_base), line);
        end
    end
    channels = names_base(2:(end-1));  % remove 'X_Value' and 'Comment'

    rows = csvio.parse_data_block( ...
        src, ...
        [], ...  % use whitespaces as the separator char
        num_channels, ...
        OMIT_XVALUE, ...
        num_channels + 1, ...
        block_size, ...
        report_interval ...
    )
    data = array2table(rows, "VariableNames", channels);
end
