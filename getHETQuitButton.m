
function quitButton = getQuitButton(handles, Text, row, column)
%This function will get the handle for the quit button.
    
    quitButton = uibutton(handles.gl);
    quitButton.Text = Text;
    quitButton.FontWeight = "bold";
    quitButton.FontSize = 16;
    quitButton.FontColor = [0 0 0];
    quitButton.Layout.Row = row;
    quitButton.Layout.Column = column;
    quitButton.BackgroundColor = [1 1 1];
    quitButton.ButtonPushedFcn = {@quitButtonFlag};
    
end %End of the function getQuitButton.m

function quitButtonFlag(src, event)
    
    %If the user clicks the close window button then close the window.
    close all force;
    closereq();

end  %End of the function quitButtonFlag.m
