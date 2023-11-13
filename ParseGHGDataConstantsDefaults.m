% ParseGHGDataConstantsDefaults - script to define locations of constants



c=computer;

if ~isempty(findstr(c,'linux'))
    % we are in cloud
    DataFilesLocation='/content/drive/Shareddrives/GHG Emissions Breakdown/DataFiles/'
    GADMFilesLocation='/content/drive/Shareddrives/Team Drive/Programs/Science/DataLibrary/GADM41/'

else
    DataFilesLocation='/Users/jsgerber/sandbox/jsg203_ClimateSolutionsExplorer/datafiles/';
    GADMFilesLocation='~/DataProducts/ext/GADM/GADM41/'
end



if exist('ParseGHGDataConstants.m')==2
    disp(['found ParseGHGDataConstants on path, executing.'])
    eval('ParseGHGDataConstants');
end