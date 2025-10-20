
function paramLabel = getParamLabel(handles, name, row, column, fontSize)
%This function will get the handle for the labels to the components in the graphical user
%interface.

    paramLabel = uilabel(handles.gl);
    paramLabel.Text = name;
    paramLabel.HorizontalAlignment = 'center';
    paramLabel.WordWrap = 'on';
    paramLabel.FontWeight = "bold";
    paramLabel.FontSize = fontSize;
    paramLabel.FontColor = [0 0 0];
    paramLabel.Layout.Row = row;
    paramLabel.Layout.Column = column;
    
end  %End of the function getParamLabel.m


