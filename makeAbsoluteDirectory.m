function absolutePath = makeAbsoluteDirectory(path)

    
    %This function will input a generic path and then create a new
    %subdirectory underneath it, if it doesn't already exist.  The function
    %returns the absolute path of the original path with the new directory
    %appended onto it.
    
    %Set up the save directory. A new directory will be made for every day.
    directoryDate = datestr(now, 'mm-dd-yyyy');

    %Generate an absolute save path.
    absolutePath = strcat(path, directoryDate);
    
    %Generate a structure holding information about the new directory.
    nameDir = dir(absolutePath);

    %Check to see if dateStr exists as a directory.  If the length of the
    %nameDir structure is zero then the directory does not exist.
    if (isempty(nameDir))
        mkdir(absolutePath);
    end  %End of the if statement - if(isempty(nameDir))

end  %End of the function makeAbsoluteDirectory.m

