clear;clc;close all

% Matrix should be in the form such that py is plotted on the left-most
% column, then px is on the top-most row. It is assumed that the range/step
% of px and py are the same

% HFSS Setup:
% set px to 180 and py to 0.
% Setup 1: Sweep px from 0 to 180, this will be Gamma to X
% Setup 2: Sweep py from 0 to 180 (with px=180), this will be X to M
% Setup 3: Sweep both px and py from 0 to 180 (make sure to link), this
% will be M to Gamma.
% Next, make an Eigenmode plot with the primary sweep as py with all px
% values selected. The y-axis should be frequency and the x-axis is phase.
% When exporting, select "Use Separate Columns for Curves"

modesToPlot = 4; %If your results include more modes than needed

fname = 'PostTest.csv';

D = readmatrix(fname);

py = D(:, 1);
px = py;
if py(1) ~= 0 || py(end) ~= 180
    error('p must be in the range of 0 to 180.')
end

D_dataOnly = D(:,2:end); %Strip py from data

%Determine the number of modes in the data
[~, dataLen] = size(D_dataOnly);
numModes = dataLen/numel(py);
if mod(numModes, 1) ~= 0
    error('Huh?');
end

%Pre-allocate
GamToX = zeros(numModes, numel(py));
XtoM = zeros(numModes, numel(py));
MtoGam = zeros(numModes, numel(py));

for n = 1:numModes
    GamToX(n, :) = D_dataOnly(1, 1+(n-1)*numel(py):n*numel(py));
    % GamToX(1, 1) = 0; %Set this to avoid convergence issues if the structure's fundamental cutoff is 0 Hz
    % MtoGam(1, end) = 0; %Set this too if fundamental cutoff is 0 Hz
    XtoM(n, :) = D_dataOnly(:, n*numel(py))';
    MtoGam(n, :) = flip(diag(D_dataOnly(:,1+(n-1)*numel(py):n*numel(py)))');
    % MtoGam(end) = 0;
end

p_plot = [py', py(end)'+py', 2*py(end)'+py'];
f_plot = [GamToX XtoM MtoGam]/1e9;

f1 = figure();
plot(p_plot, f_plot(1:modesToPlot, :))
ylabel('Frequency (GHz)')
grid on
% xlim([min(p_plot), max(p_plot)])
xlGam = xline(0, 'k', '\Gamma', 'LabelOrientation', 'horizontal');
xlX = xline(1*180, 'k', 'X', 'LabelOrientation', 'horizontal');
xlM = xline(2*180, 'k', 'M', 'LabelOrientation', 'horizontal');
xlGam2 = xline(3*180, 'k', '\Gamma', 'LabelOrientation', 'horizontal');
xlGam.FontSize = 30;
xlX.FontSize = 30;
xlM.FontSize = 30;
xlGam2.FontSize = 30;

% yticks(0:50:ceil(max(max(f_plot))))
f1.Position = [307   330   977   635];
formatFig(f1, 4, 30)
