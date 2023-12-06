function [ISOlist,CountryNameList]=ParseGHGCountriesList;
% ParseGHGCountriesList - name of countries in Minx Data
persistent ISOlist_p CountryNameList_p

if isempty(ISOlist_p)

ParseGHGDataConstantsDefaults
datadir=DataFilesLocation;
c=readgenericcsv([datadir 'essd_ghg_data_gwp100_datasheet.txt'],1,tab);

ISOlist_p=unique(c.ISO);

for j=1:numel(ISOlist_p);
    idx=strmatch(ISOlist_p{j},c.ISO);
    CountryNameList_p{j}=c.country(idx(1));
end

end

CountryNameList=CountryNameList_p;
ISOlist=ISOlist_p;

