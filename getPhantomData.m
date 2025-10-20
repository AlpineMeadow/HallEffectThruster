%This script will get the Phantom camera data from a set of .tif files.  It
%will hold the files in a structure.

dbstop if error;

clearvars;
close all;
fclose('all');

%The user will need to specify the location of the .tif files.  For
%example, if the files are located in the Documents folder the user would
%set baseDir= "C:\Users\[user name]\Documents\";

%The baseFilename would be the beginning part of the tif files you want to
%load.  For example, if the files are named ['Phantom_0904240001.tif', 
%'Phantom_0904240002.tif', Phantom_0904240003.tif', ....] then the
%user would set the variable to be baseFilename = 'Phantom_090424';  The
%numbers are used to give a unique name to each file.  

%Finally the user can insert the start and end indices in the case that the
%user wants a specific subset of the entire set of files.  These can be
%numbered as regular numbers such as 1 and 10.  If the user wants to use
%all of the files then set the start index to zero and the end index to
%zero.
baseDir = '/SS1/HallEffectThruster/Data/';
baseFilename = 'Phantom_090424';
startIndex = 1;
endIndex = 443;
phantomData = getPhantomCameraData1(baseDir, baseFilename, startIndex, ...
                endIndex);

%Lets get the size of the data array.
[width, height, numImages] = size(phantomData);

%Now pick out a group of pixels by its row and column numbers and also set
%the size of the pixels to average over.
col = 1;
row = 1;
pixelBoxSize = 2;

%Generate an array that will hold the average and standard deviation of the
%pixels around the chosen pixel.
bright = zeros(numImages, 1);
brightSTD = zeros(numImages, 1);

%Loop through all of the tiff files of interest and calculate the mean and
%standard deviation of the chosen pixel.
for k = 1 : numImages
    bright(k) = mean(PhantomData(row : row + pixelBoxSize, ...
                col : col + pixelBoxSize, k), 'all');
    brightSTD(k) = std(PhantomData(row : row + pixelBoxSize, ...
                col : col + pixelBoxSize, k), 0, 'all', 'omitnan');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%getPhantomCameraData1%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function PhantomData = getPhantomCameraData1(baseDir, baseFilename, ...
                        startIndex, endIndex)

%This function will read in a series of .tif files
%and return an array of the values.
%This function is called by getPhantomData.m

%Generate a cell array of all of the files in the baseDir directory.
dirStruct = dir(baseDir);
allFilenames = {dirStruct.name};

%Since matlab includes the "." and ".." files (which point to the present
%and above directories and we are not interested in those we exclude them.
filenames = allFilenames(3 : end);

%Now lets find the length of the number part of the filename.  The 4 at the
%end is due to the length of '.tif';  The variable filenames(1) is a cell.
%We need to convert that to a string and then a char array so that we can
%index into the letters.
numNumbers = length(char(string(filenames(1)))) - length(baseFilename) - 4;

%Handle the case for when the user input 0's for the starting and ending
%indices.
if startIndex == 0
    %Now convert the cell array into a char array so that we can index into the
    %characters.  First convert the cell array into a string array.
    fnames = char(string(filenames));

    %Now get the file index values.
    firstFileIndex = str2double(fnames(1, length(baseFilename) + 1 : end - 4, ...
                                   1));
    lastFileIndex = str2double(fnames(1, length(baseFilename) + 1 : end - 4, ...
                                    length(fnames)));
    
    %Set up the starting and ending indices strings.
    startIndexStr = num2str(firstFileIndex, ['%0', num2str(numNumbers), 'd']);
    endIndexStr = num2str(lastFileIndex, ['%0', num2str(numNumbers), 'd']);
else
    %Set up the starting and ending indices strings.
    startIndexStr = num2str(startIndex, ['%0', num2str(numNumbers), 'd']);
    endIndexStr = num2str(endIndex, ['%0', num2str(numNumbers), 'd']);
end

%Generate a matlab save file name.
PhantomSaveFileName = [baseDir, 'SaveFile', baseFilename, '_', ...
        startIndexStr '-', endIndexStr, '.mat'];

%We write a save file for these data as it can take a long time to load in
%the data files.  It is quicker to just do this once and then save and load
%a save file.
%Check to see if the save file exists.
if isfile(PhantomSaveFileName)

    %The file has already been processed, so read in the data from the .mat
    %file.
    disp(['Reading in the save file : ', PhantomSaveFileName])
    PhantomData = load(PhantomSaveFileName)
else
    %The save file does not exist.  Generate the data array and then save
    %it as a save file.

    %Find the starting and ending index values.
    startFileIndex = str2double(startIndexStr);
    endFileIndex = str2double(endIndexStr);
    numFilesToImport = endFileIndex - startFileIndex;

    %Lets pre-allocate the array to hold the files.
    numPixelsWidth = 128;
    numPixelsLength = 256;
    PhantomData = zeros(numPixelsWidth, numPixelsLength, numFilesToImport);

    %Loop through the files.
    for index = startFileIndex : endFileIndex

        fileNumber = num2str(index, ['%0', num2str(numNumbers), 'd']);

        %Generate a file name.
        filename = [baseDir, baseFilename, fileNumber, '.tif'];

        %Sometimes the files are corrupted.  There seems to be no way to
        %manage this by checks until Matlab actually calls imread and then
        %we get the bad news.  I have added the isfile command to at least
        %check to see if the file exists, corrupted or not.
        if isfile(filename) 
            %Read in the cine file.
            img = imread(filename);
            PhantomData(:, :, index - startFileIndex + 1) = img;
        else
            continue
        end  %End of if-else statement - if isfile(filename)

    end  %End of for loop - for index = startFileIndex : endFileIndex

    %Now write it out as a matlab .mat file.
    save(PhantomSaveFileName, "PhantomData")

end  %End of if-else clause - if isfile(PhantomSaveFileName)

end  %End of function getPhantomCameraData.m