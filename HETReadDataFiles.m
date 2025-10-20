%Read in the data files produced by the ESASweeper.m program.  The data
%files were saved using matlab's fwrite function.  They are in binary
%format.  Once the data files are read in then calculate the standard
%deviation for each of the TIA signals and then plot the standard
%deviations as a function of time.


%Set the date that the data were taken.
day = '10';
month = 'Nov';
year = '2021';
date = [day '-' month '-' year];

%Generate a structure containing the names of the binary files we want to
%read in.
fileNames = dir([date, '\*.bin']);
[numOfFiles, x] = size(fileNames);

%Allocate a vector of standard deviations.
standardDevs = zeros(1, numOfFiles);

%Allocate a vector that will contain the hours, minutes and seconds the data
%were recorded.
hhmmss = strings(1, 2*numOfFiles);

%Label the columns in the data files.
MonitorVoltage = 2;
TIAVoltage = 1;

%Determine the number of rows and columns.
stopV = 4.9;
startV = 0;
deltaV = 0.005;

%Calculate the number of rows and then multiply by two since we wrote
%upsweep and downsweep with two stops at each voltage step.
numRows = 2*((stopV - startV)/deltaV + 1);
numCols = 2;

%Give the precision with which the data were written.
precision = 'double';

for i = 1 : numOfFiles
    fName = [date, '\', fileNames(i).name];
    
    a = (2*i) - 1;
    b = 2*i;
  
    hhmmss(a : b) = [fName(24:25) ':' fName(27:28) ':' fName(30:31)];
 
    %Read in the file.
    fileID = fopen(fName, 'r');
    realdata = fread(fileID, [numRows numCols], precision);
    fclose(fileID);
    
    standardDevs(i) = std(realdata(:, TIAVoltage));
    
end

%Make a vector of times.  Since the stupid way matlab does strings we need
%to multiply by two in order to get the correct indexing.
times = [hhmmss(1); hhmmss(400); hhmmss(800); hhmmss(1200); hhmmss(1600); ...
    hhmmss(2000); hhmmss(2400); hhmmss(2800); hhmmss(3200); hhmmss(3600); hhmmss(3986)];

%Plot the figure.
fig = figure(1);
plot(standardDevs, '.')
title('TIA Standard Deviation Vs Thruster Parameter Variations')
ylabel('Standard Deviation')
set(gca, 'XLim', [0 2000])
set(gca, 'XTick', [1 200 400 600 800 1000 1200 1400 1600 1800 1993])
set(gca, 'XTickLabels', times)
xtickangle(45)

%Save the figure.  
saveas(fig, ['Standard_Deviations_Hall_Thruster_', date, '.pdf'])
        
