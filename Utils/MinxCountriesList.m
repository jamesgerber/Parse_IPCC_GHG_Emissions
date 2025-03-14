function [ISOlist,CountryNameList,ii]=MinxCountriesList(ISO);
% MinxCountriesList - name of countries in Minx Data
%
% Syntax:
%
%   ISOlist=MinxCountriesList
%
%  [ISOlist,CountryNamelist]=MinxCountriesList;
%  [ISOlist,CountryNamelist,idx]=MinxCountriesList;
%
%  If you pass in a single ISO code, you'll get out a single country name.
%
%   CountryName=MinxCountriesList(ISO)
%
%  Pass in a number and get out an ISO code
%
%  Request 3 args out and the 3rd will be what you need to map onto a 5
%  minute grid.
%
% fun times:
% [a,b]=MinxCountriesList;
% [a b]


if nargin==1
    OriginalArgIn=ISO;

    if isnumeric(ISO);
        templist=MinxCountriesList;
        ISO=templist{ISO};
    end
end


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

CountryNameList=CountryNameList_p(:);
ISOlist=ISOlist_p;


if nargin==1 & ~isnumeric(OriginalArgIn)
    idx=strmatch(ISO,ISOlist);
    ThisCountry=CountryNameList{idx};
    CountryNameList=ThisCountry;
    ISOlist=ThisCountry;
elseif nargin==1
    idx=strmatch(ISO,ISOlist);
    ThisCountry=CountryNameList{idx};
    CountryNameList=ThisCountry;
    ISOlist=ISO;
end


if nargout==3 & nargin==0
    error('dont ask for three outputs with 0 inputs')
end

if nargout<3
    return
end

persistent g0

if isempty(g0);
    g0=getgeo41_g0;
end

idx=strmatch(ISO,g0.gadm0codes);
switch ISO
    case {'AIR','ANT','HKG','MAC','SCG','SEA'}
        ii=logical(datablank);
    otherwise
        
        ii=(g0.raster0==idx);
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
