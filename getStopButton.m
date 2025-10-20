function stopButton = getStopButton(handles, Text, row, column)
%This function will get the handle for the stop button.
    
    stopButton = uibutton(handles.gl);
    stopButton.Text = Text;
    stopButton.FontWeight = "bold";
    stopButton.FontSize = 16;
    stopButton.FontColor = [0 0 0];
    stopButton.Layout.Row = row;
    stopButton.Layout.Column = column;
    stopButton.BackgroundColor = [1 0 0];
    stopButton.ButtonPushedFcn = {@stopButtonFlag};

end %End of the function getStopButton.m


function stopButtonFlag(src, event)


%Here we will just send the controller the quit command.
    %Get the data out of the application data of the figure object.
    handles = guidata(src);

    if handles.stopButton.UserData == 1  %stopButtonFlag is set to 1.

        handles.stopButton.UserData = 0;
        handles.startButton.UserData = 1;

    else

        handles.stopButton.UserData = 1;
        handles.startButton.UserData = 0;

    end %End of if-else clause.

end  %End of the function stopButtonFlag.m
