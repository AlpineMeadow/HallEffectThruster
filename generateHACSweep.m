function generateHACSweep(handles, fig, HACDAQ)
%This function will generate the HAC sweep voltage profile.

%Check to see if the user wants to save the files that are produced.        
writeData = 1;  %Set write to zero as the default value.
writeData = handles.saveDataButton.UserData;
    
%Check to see if the user wants to save the plots that are produced.
savePlot = 1;
savePlot = handles.savePlotButton.UserData;
    
%Pull the params vector out of the handles structure.
params = handles.params;
    
%Set up the save path.
savePath = "C:\Users\DF_Local\Hall Effect Thruster\";    
%absoluteSavePath = makeAbsoluteDirectory(savePath);        

%Set up the save directory. A new directory will be made for every day.
%directoryDate = datestr(now, 'mm-dd-yyyy');

%Generate an absolute save path. 
%absolutePath = strcat(savePath, directoryDate);

%Write the profile to the DAQ.
d = zeros(1, params(5))';
[rawData, rawTime, triggerTime] = readwrite(HACDAQ.s, d, 'OutputFormat', 'Matrix');
data = 1.0*rawData; 
time = rawTime;  
        
offsetBias = 0.04;

%Make a plot of the data.
plot(rawTime, offsetBias + data)
xlim([0,0.5e-3])
%ylim([-2.0, 2.0])
grid on
title("Voltage of Anode Current of HET")
xlabel("Time (sec)")
ylabel("Voltage (V)")

    
%generate a matrix to save.    
saveMatrix = [time, data];

%Write the plot to a file
if savePlot       
    %Set up a plotting directory.        
    plotPath = "C:\Users\DF_Local\Hall Effect Thruster\Plots\";    
    %absolutePlotPath =  strcat(plotPath, directoryDate);
    absolutePlotPath = makeAbsoluteDirectory(plotPath); 

    %Set up a plot file name.    
    plotFileName = strcat(absolutePlotPath, '\', 'HACAnodeCurrent', ...
            datestr(now, 'HH-MM-SS'), '.png');
    saveas(fig, plotFileName);
end

%Write the data file if the user requests.
if writeData
    %Set up a data directory.        
    dataPath = "C:\Users\DF_Local\Hall Effect Thruster\Data\";    
    absoluteDataPath = makeAbsoluteDirectory(dataPath); 

    dataFileName = ['AnodeCurrent_', datestr(now, 'mm-dd-yyyy-HH-MM-SS'), '.mat'];

    fileName = strcat(absoluteDataPath, '\', dataFileName);
    save(filename, "time", "data");
end %End of if statement - if write 
         
end  %End of the function generateHACSweep.m


function generateHACPlots(fig, time, data)
%Generate a plot of the TIA output voltage as a function of time.

    
    % subplot(3,1,1)
    % plot(120.0*monitorVoltage, TIAVoltage, '.')
    % %plot(time, TIAVoltage)
    % title({'Plot of TransImpedence Amplifier(TIA) Output Voltage' , 'Versus Normalized Sweep Voltage'})
    % xlabel('(Sweep Voltage) * 120.0 (eV)')
    % ylabel('TIA Voltage (V)')
    % 
    % %Generate a plot of the Monitor voltage as a function of time.
    % subplot(3,1,2)
    % plot(time, monitorVoltage)
    % ylim([startV peakV])
    % title('Plot of Monitor Voltage as a function of time')
    % xlabel('Time (s)')
    % ylabel('Voltage (V)')

    % %Generate a plot of the input sweep voltage as a function of time.
    % subplot(3,1,3)
    % plot(rawTime, sweepProfile)
    % title('Plot of Input Voltage as a function of time')
    % ylim([startV peakV])
    % xlabel('Time (s)')
    % ylabel('Voltage (V)')
   
    % plot(data)
    % title("Current measured from the anode of the HET")
    % xlabel("Time (micro-sec)")
    % ylabel("Current (mV)")
    
end  %End of the function generateHACPlots.m


 

