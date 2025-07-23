%
% plot-dlc
%
% reads the data from a DLC output file (as a CSV file)
% and plots the 2D trace of one keypoint.
%
% optionally, a threshold may be set to invalidate
% low-likelihood predictions.
%

clear  % clears the environment
clc    % clears the console output

%% set up parameters

%
% modify the values according to your needs
%

SOURCE_FILE = "~/Downloads/DLC/testfile_DLC_shuffle1_test.csv";
FRAME_WIDTH = 600;
FRAME_HEIGHT = 500;
LABEL_NAME = "rightpawcenter";

assert(isfile(SOURCE_FILE));

%% load data

[data, header] = csvio.read_dlc(SOURCE_FILE);

%% display metadata

fprintf("[file '%s']\n", SOURCE_FILE);
fprintf("scorer: %s\n", header.scorer);
fprintf("labels (%d rows):\n", size(data, 1));
for i = 1:length(header.labels)
    fprintf("  - %s\n", header.labels(i));
end
clear i

%% extract x/y coordinates (+likelihood)

point_x = data.(sprintf("%s_x", LABEL_NAME));
point_y = data.(sprintf("%s_y", LABEL_NAME));
point_p = data.(sprintf("%s_p", LABEL_NAME));

%% (optional) check the distribution of likelihood values

figure('Name', 'Likelihood-ditribution');
histogram(point_p, linspace(0, 1, 100));
xlim([0, 1]);

%% filter the trace based on the likelihood

%
% again, modify the values below (THRESHOLD, SAMPLING_RATE)
% according to your needs
%
THRESHOLD = 0.8;
SAMPLING_RATE = 100;

if THRESHOLD > 0
    below = (point_p < THRESHOLD);
    point_x(below) = NaN;
    point_y(below) = NaN;
end

%% plot in 2D

% timebase: this time, the values will be used
% to color the points according to the ellapsed time
t = (1:length(point_x)) / SAMPLING_RATE;
marker_size = 2;

figure('Name', '2D-plotting');
scatter(point_x, point_y, marker_size, t, 'filled', 'o', ...
    'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 0.2);
xlim([0, FRAME_WIDTH]);
ylim([0, FRAME_HEIGHT]);
set(gca, 'YDir', 'reverse');
