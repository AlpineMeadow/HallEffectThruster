
function savePlotButton = getSavePlotButton(handles, Text, row, column)
%This function will get the handle for the stop button.
    
    savePlotButton = uicheckbox(handles.gl);
    savePlotButton.Text = Text;
    savePlotButton.FontWeight = "bold";
    savePlotButton.FontSize = 24;
    savePlotButton.FontColor = [0 0 0];
    savePlotButton.Layout.Row = row;
    savePlotButton.Layout.Column = column;
    savePlotButton.ValueChangedFcn = {@savePlotButtonFlag};

end %End of the function getStopButton.m

function savePlotButtonFlag(src, event)
%Here we will just send the controller the quit command.
    %Get the data out of the application data of the figure object.
    handles = guidata(src);

    if handles.savePlotButton.UserData == 1  %savePlotButtonFlag is set to 1.

        handles.savePlotButton.UserData = 1;

    else  %savePlotButtonFlag is set to 0.

        handles.savePlotButton.UserData = 0;

    end %End of if-else clause.

end  %End of the function savePlotButtonFlag.m
