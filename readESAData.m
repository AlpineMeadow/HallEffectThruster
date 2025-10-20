%Matlab script to read in data files from EPEE ESA.
clearvars;

%Sdd the path to the location of the files to matlab's path.
addpath('c:\Users\DF_Local\EPEE ESA\Matlab Code\');


%The data are located in the following directory.
baseDir = 'C:\Users\DF_Local\EPEE ESA\Data\';
plotDir = 'C:\Users\DF_Local\EPEE ESA\Plots\';

%Set the date.
day = '15';
month = '02';
year = '2022';
date = [month '-' day '-' year];

fileNames = dir([baseDir, date, '\*.mat']);
[numOfFiles, x] = size(fileNames);


%Loop through the files.
for i = 1 : numOfFiles
    %Load the data.
    load([baseDir, date, '\', fileNames(i).name]);

    %Pull the hour, minute and second values out of the title of the data file.
    hour(i) = str2num(fileNames(i).name(12:13));
    minute(i) = str2num(fileNames(i).name(15:16));
    second(i) = str2num(fileNames(i).name(18:19));

    %Make arrays out of each of the saved values by appending the newly read in
    %value to the array.
    timeArray(:, i) = time;
    TIAArray(:, i) = TIAVoltage;
    MonitorArray(:, i) = monitorVoltage;
end


%The timeArray, TIAArray and MonitorArray matrices are (Number of time samples) X
%(number of data files) in size.
%The last 27 (136:163) files are with the Hall thruster off.
%Lets average some of the TIAArray values together.
numToAverage = 100;
startIndex = 2;
endIndex = startIndex + numToAverage;

%Now get the average of a few instances.
averageTIA = sum(TIAArray(:, startIndex : endIndex), 2)/numToAverage;
averageMonitor = sum(MonitorArray(:, startIndex : endIndex), 2)/numToAverage;

%Lets compare the two downward pulses.  The second half of the data should be
%flipped otherwise we will not be comparing properly.
firstHalfTIA = averageTIA(1:1000,1);
secondHalfTIA = flip(averageTIA(1001:2000, 1));



%Generate the ESA sweep voltage.

startV = 0.0;
peakV = 4.5;
sampleRate = 1000;
numVoltageChanges = 10;
totalTimeLength = 2.0;


totalPoints = totalTimeLength*sampleRate;
pointsUp = floor(totalPoints/2);
pointsDown = pointsUp;

numEntriesSingleVoltage = floor(pointsUp/(numVoltageChanges - 1));
deltaV = (peakV - startV)/(numVoltageChanges - 1);


numSectors = floor(totalPoints/numEntriesSingleVoltage);
upsweep = zeros(1, pointsUp);
downsweep = zeros(1, pointsDown);

for i = 0 : floor(numSectors/2) - 1
    ups = startV + i*deltaV;
    downs = peakV - i*deltaV;

    for j = 1 : numEntriesSingleVoltage
    	index = i*numEntriesSingleVoltage + j;

	upsweep(index) = ups;
	downsweep(index) = downs;
    end
end

%Handle the edges.
startEdgeIndex = numEntriesSingleVoltage*numSectors/2;
endEdgeIndex = sampleRate;
upsweep(startEdgeIndex : endEdgeIndex) = peakV;
downsweep(startEdgeIndex : endEdgeIndex) = deltaV;

sweepProfile = [upsweep, downsweep];


%Make a plot of the input data and the monitor voltage.
titleStr = 'Monitor Voltage and Sweep Input Versus Time';
indexStart = 1400;
indexEnd = 1610;
fig1 = figure();
plot(timeArray(indexStart : indexEnd, 1), sweepProfile(indexStart : indexEnd), 'b.')
hold on
plot(timeArray(indexStart : indexEnd, 1), averageMonitor(indexStart : indexEnd), 'g.')
%ylim([0 4.6])
xlabel('Time (s)')
ylabel('Voltage (V)')
title(titleStr)
legend("Sweep Profile", "Average Monitor", "Location", 'southeast')

saveFileName = [plotDir, 'SweepProfileAndMonitorVoltage_', date, '.pdf'];
saveas(fig1, saveFileName)



%Now plot the results.
makePlot = 0;

if (makePlot)
   titStr = sprintf('Average of %d Runs For xTIA Voltage Runs Versus Time', ...
      numToAverage);	
   fig1 = figure();
   plot(timeArray(:, 1), averageTIA, 'b.')
   title(titStr)
   ylim([-0.3 0.1])
   ylabel('Average Voltage (V)')
   xlabel('Time (s)')

   saveas(fig1, 'AverageTIA02152022.pdf')


   fig2 = figure();
   plot(firstHalfTIA, 'b.')
   title(titStr)
   ylim([-0.3 0.1])
   ylabel('Average Voltage (V)')
   xlabel('Time (s)')

   hold on

   plot(secondHalfTIA, 'r.')

   legend({'First Half of Data', 'Reversed Second Half of Data'}, 'Location', 'southeast')

   saveas(fig2, 'AverageOverlapTIA02152022.pdf')


   titStr = sprintf('Average of %d Runs For TIA Voltage Versus Average Monitor Voltage', ...
         numToAverage);
	 
   fig3 = figure();
   plot(averageMonitor, averageTIA, 'b.')
   title(titStr)
   ylim([-0.3 0.1])
   xlim([0 4.5])
   ylabel('Average TIA Voltage (V)')	
   xlabel('Average Monitor Voltage (V)')

   saveas(fig3, 'AverageTIAMonitor02152022.pdf')


   titStr = sprintf('Average of %d Runs For TIA Voltage Versus Calculated Ion Energy', ...
      numToAverage);
      
   fig4 = figure();
   plot(120*averageMonitor, averageTIA, 'b.')
   title(titStr)
   ylim([-0.3 0.1])
   xlim([0 550])
   ylabel('Average TIA Voltage (V)')
   xlabel('Ion Energy (eV)')

   saveas(fig4, 'AverageTIAEnergy02152022.pdf')
	     
end

%Now fit the data.
titStr = sprintf('Fitted Average of %d Runs For TIA Voltage \n Versus Average Monitor Voltage', ...
	 numToAverage);
saveFileName = ['FittedTIAMonitor_', date, '.pdf'];
[fitResult, gof] = fitOneGaussian(averageMonitor, averageTIA, titStr, saveFileName);


titStr = sprintf('Fitted Average of %d Runs For TIA Voltage \n Versus Average Monitor Voltage', ...
       numToAverage);
saveFileName = [plotDir, 'FittedTIAFirstHalfSecondHalf_', date, '.pdf'];
[fitResult, gof] = fitTwoGaussians(time, firstHalfTIA, secondHalfTIA, titStr, saveFileName);

