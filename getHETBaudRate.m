function baudRate = getBaudRate(handles, params, initialValue, row, column, position)
%This function will get the handle for each of the components in the graphical user interface. 

    baudRate = uieditfield(handles.gl, 'numeric');
    baudRate.Value = initialValue;
    baudRate.Layout.Row = row;
    baudRate.Layout.Column = column;
    baudRate.ValueChangedFcn = {@changeBaudRate, params, position};

end %End of the function getBaudRate.m

function changeBaudRate(src, event, param, position)
%This function will put the new parameter into the param vector.
    
    %Get the data out of the application data of the figure object.
    handles = guidata(src);

    %Set the new value into the params vector.
    handles.params(position) = param.Value;

    %Now store the new values back into the application data of the figure object.
    guidata(src, handles);
    
end  %End of the function changeBaudRate.m

