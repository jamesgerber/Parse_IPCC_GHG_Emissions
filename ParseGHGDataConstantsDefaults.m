% ParseGHGDataConstantsDefaults - script to define locations of constants

% this code will populate some defaults which will be overwritten if there
% is a file called ParseGHGDataConstants.m on the path

c=computer;

if ~isempty(findstr(c,'linux'))
    % we are in cloud
    DataFilesLocation='/content/drive/Shareddrives/GHG Emissions Breakdown/DataFiles/'
    GADMFilesLocation='/content/drive/Shareddrives/Team Drive/Programs/Science/DataLibrary/GADM41/'
    PopulationDataLocation='/content/drive/Shareddrives/Team Drive/Programs/Science/DataLibrary/Population/'
else
    DataFilesLocation='/Users/jsgerber/sandbox/jsg203_ClimateSolutionsExplorer/datafiles/';
    GADMFilesLocation='~/DataProducts/ext/GADM/GADM41/';
    PopulationDataLocation='~/DataProducts/ext/Population/';
    
end

% note DataFilesLocation should contain a subdirectory called
% DESDataGatewayFiles/

if exist('ParseGHGDataConstants.m')==2
    disp(['found ParseGHGDataConstants on path, executing.'])
    eval('ParseGHGDataConstants');
end