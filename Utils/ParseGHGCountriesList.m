function ISOlist=ParseGHGCountriesList;
ParseGHGDataConstantsDefaults

geo=load([GADMFilesLocation 'gadm41_level0raster5minVer1.mat'],'gadm0codes');
ISOlist=geo.gadm0codes;

ISOlist(end+1)=    {'AIR'};
ISOlist(end+1)=    {'ANT'};
ISOlist(end+1)=    {'HKG'};
ISOlist(end+1)=    {'MAC'};
ISOlist(end+1)=    {'SCG'};
ISOlist(end+1)=    {'SEA'};