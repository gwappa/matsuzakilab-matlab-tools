function blocks = compute(vec)
    % blocks = block1d.COMPUTE(vec)
    % 
    % finds blocks of same values and returns as a table (start/stop/value).
    %
    % @version 1.0.0
    % @author gwappa
    % @license MIT

    % find jumps
    dvec = diff(vec);
    dvec(length(vec)) = 0;
    jumps = find(dvec ~= 0);

    % structure
    startidx           = ones(length(jumps)+1, 1);
    startidx(2:end)    = jumps + 1;
    stopidx            = ones(length(jumps)+1, 1) * length(vec);
    stopidx(1:(end-1)) = jumps;
    blockvalue = reshape(vec(startidx), [], 1);

    blocks = table;
    blocks.start = startidx;
    blocks.stop  = stopidx;
    blocks.value = blockvalue;
end

% MIT License
%
% Copyright (c) 2022 Keisuke Sehara
%
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
%
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% SOFTWARE.
