function handles = getHACHandles(HACDAQ, baudrate)

%A function to get the GUI handles.

%Set up a vector of 4 parameters.
    params = zeros(1, 5);
    
    % startV = 0.0;  %The starting voltage (in Volts).
    % peakV = 2.5; %The peak voltage (in Volts).
    % deltaV = 0.005; %The change in voltage (in Volts).
    % sweepDuration = 4.0;  %The duration of the sweep profile (in seconds).
    baudRate = baudrate;
    
    % params(1) = startV;  
    % params(2) = peakV;
    % params(3) = deltaV;
    % params(4) = sweepDuration;
    params(5) = baudRate;
    
    %Put the param vector into the handles structure.
    handles.params = params;
    
    %Generate a user interface.
    fig = uifigure;
    fig.Name = "Current Monitor Digital Data";
    fig.Position = [400 24 470 450];

    %Generate a grid layout for the user interface.
    handles.gl = uigridlayout(fig, [11 5]);

    %Set the heights and widths of the components in the user interface.
    handles.gl.RowHeight = {50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50};
    handles.gl.ColumnWidth = {25, 150, 75, 150, 25};

    %Set up the graphical user interface components.

    %Generate the label for the stage.
    row = 1;
    column = [1 4];
    color = [0 0 0];
    handles.HACLabel = getHACLabel(handles, "Current Monitor", row, column, color);

    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
   
    
    %Generate the label for setting the baud rate.
    row = 2;
    column = 2;
    label = 'Set Baud Rate';
    fontSize = 16;
    handles.setBaudRateLabel = getParamLabel(handles, label, row, column, fontSize);
      
    %Generate the baud rate component.
    initialValue = baudRate;
    row = 2;
    column = 4;
    position = 1;
    handles.setBaudRate = getBaudRate(handles, params, initialValue, row, column, position);


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %Generate the save data button component.
    label = "Do Not Save Data To File?";
    row = 3;
    column = [2 5];
    handles.saveDataButton = getSaveDataButton(handles, label, row, column);
    handles.saveDataButton.UserData = 1;


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %Generate the save plot component.
    label = "Do Not Save Plot To File?";
    row = 4;
    column = [2 5];
    handles.savePlotButton = getSavePlotButton(handles, label, row, column);
    handles.savePlotButton.UserData = 1;


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %Generate the start button component.
    label = "Start";
    row = 5;
    column = [2 4];
    handles.startButton = getStartButton(handles, label, row, column, HACDAQ);
    handles.startButton.UserData = 1;
    
    %Generate the stop button component.
    label = "Stop";
    row = 6;
    column = [2 4];
    handles.stopButton = getStopButton(handles, label, row, column);
    handles.stopButton.UserData = 0;
    
    %Generate the quit button component.
    label = "Close Window";
    row = 7;
    column = [2 4];
    handles.quitButton = getQuitButton(handles, label, row, column);

    %This command causes the handle structure to be stored in the application data of the
    %figure object.
    guidata(fig, handles);
        
end  %End of the function getHACHandles.m

