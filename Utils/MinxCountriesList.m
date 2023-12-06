function [ISOlist,CountryNameList]=MinxCountriesList(ISO);
% MinxCountriesList - name of countries in Minx Data
%
% Syntax:
%
%   ISOlist=MinxCountriesList
%
%   CountryName=MinxCountriesList(ISO)
%
persistent ISOlist_p CountryNameList_p

if isempty(ISOlist_p)
    
    ParseGHGDataConstantsDefaults
    datadir=DataFilesLocation;
    c=readgenericcsv([datadir 'essd_ghg_data_gwp100_datasheet.txt'],1,tab);
    
    ISOlist_p=unique(c.ISO);
    
    for j=1:numel(ISOlist_p);
        idx=strmatch(ISOlist_p{j},c.ISO);
        CountryNameList_p{j}=c.country{idx(1)};
    end
    
end

CountryNameList=CountryNameList_p;
ISOlist=ISOlist_p;


if nargin==1
    idx=strmatch(ISO,ISOlist);
    ThisCountry=CountryNameList{idx};
    CountryNameList=ThisCountry;
    ISOlist=ThisCountry;
end



return


%% here is some code I used to convince myself that this list has everything (i.e.
%%nothing in EDGAR that isn't in Minx


ISOlist=MinxCountriesList;

emsum=0;
for j=1:numel(ISOlist);
    [M,rows,cols,A,B,OE,IND,T,E]=AllocateEmissionsNFIRevG(ISOlist{j},2019);
    emsum=emsum+sum(M(:));
end
