%
% parse-lvm
%
% reads the data from the LVM file
% and detects lick events
%

clear  % clears the environment
clc    % clears the console output

%% set up parameters

%
% modify the values according to your needs
%

SOURCE_FILE = "~/Downloads/LVM/test_lvm_short.lvm";
LICK_SENSOR_COLUMN = 'Lick';

assert(isfile(SOURCE_FILE));

%% load data

[data, header] = csvio.read_lvm(SOURCE_FILE);
sampling_rate = str2double(header.Table.Samples{1});

%% extract lick-sensor readings

lick_sensor_values = data.(LICK_SENSOR_COLUMN);
t = (1:length(lick_sensor_values)) / sampling_rate;

%% plot raw lick-sensor trace

figure('Name', 'Lick-sensor');
plot(t, lick_sensor_values, 'k-');
xlim([0, 60]);

%% threshold the trace to detect lick events

%
% again, modify the value below (THRESHOLD)
% according to your needs
%
THRESHOLD = 2.7;

lick_events = block1d.detect_pulses(lick_sensor_values >= THRESHOLD);

%% (TODO) filter the lick events

%
% due to the natuer of the lick sensor,
% it is likely that there are 'events' that are
% unreasonably short or long with respect to the
% physiology of the animals' licks.
%
% it is up to who analyzes the data on
% whether and how to filter out these 'unphysiological' lick events.
%

%% plot the lick event onset

figure('Name', 'Lick-onset');
plotting.raster(t(lick_events.start), 0, 1, 'k-', 'LineWidth', 1.5);
xlim([0, 60]);
ylim([-1, 2]);
