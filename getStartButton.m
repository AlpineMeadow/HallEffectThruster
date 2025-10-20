function startButton = getStartButton(handles, Text, row, column, HETDAQ)
%This function will get the handle for the start button.    

    startButton = uibutton(handles.gl);
    startButton.Text = Text;
    startButton.FontWeight = "bold";
    startButton.FontSize = 16;
    startButton.FontColor = [0 0 0];
    startButton.Layout.Row = row;
    startButton.Layout.Column = column;
    startButton.BackgroundColor = [0 1 0];
    startButton.ButtonPushedFcn = {@startLoopingInputSignal, HETDAQ};
                                                                           
end %End of the function getStartButton.m


function startLoopingInputSignal(src, event, HETDAQ)
%This function will run the loop that sends the data to the daq.

    %Generate a figure handle.
    fig = figure();
    fig.Position = [400 50 870 450];
    
    True = 1;
    while True
        
        %Get the data out of the application data of the figure object.
        handles = guidata(src);

        %Set the start and stop button value.  If startButton.Value = 1 then we have started
        %the loop.  Likewise in order for the loop to run we set stopButton.Value = 0.  
        handles.startButton.UserData = 1;
        handles.stopButton.UserData = 0;
       
        %HET sweep code goes here.
        generateHETSweep(handles, fig, HETDAQ);
        
        pause(0.1);  %This is needed in order to see the stop interrupt.

        if handles.stopButton.UserData == 1
            break;
        end  %End of if statement.

    end  %End of the while loop
end  %End of the function startLoopingInputSignal.m
