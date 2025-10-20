   
function saveDataButton = getSaveDataButton(handles, Text, row, column)
%This function will get the handle for the stop button.
    
    saveDataButton = uicheckbox(handles.gl);
    saveDataButton.Text = Text;
    saveDataButton.FontWeight = "bold";
    saveDataButton.FontSize = 24;
    saveDataButton.FontColor = [0 0 0];
    saveDataButton.Layout.Row = row;
    saveDataButton.Layout.Column = column;
    saveDataButton.ValueChangedFcn = {@saveDataButtonFlag};

end %End of the function getStopButton.m


function saveDataButtonFlag(src, event)
%Here we will just send the controller the quit command.
    %Get the data out of the application data of the figure object.
    handles = guidata(src);

    if handles.saveDataButton.UserData == 1  %saveDataButtonFlag is set to 1.

        handles.saveDataButton.UserData = 0;

    else  %saveDataButtonFlag is set to 0.

        handles.saveDataButton.UserData = 1;

    end %End of if-else clause.

end  %End of the function saveDataButtonFlag.m
