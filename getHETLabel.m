function ESALabel = getESALabel(handles, name, row, column, color)
%This function will place a label of "Stage at the top of the graphical user
%interface.
    
    ESALabel = uilabel(handles.gl);
    ESALabel.Text = name;
    ESALabel.FontWeight = "bold";
    ESALabel.FontSize = 24;
    ESALabel.FontColor = color;
    ESALabel.Layout.Row = row;
    ESALabel.Layout.Column = column;
    ESALabel.HorizontalAlignment = "center";

end %End of the function getESALabel.m
