function ParseAndDisplayEmissions_RegionSpecificTables(ISOlist,RegionName,YYYY)

persistent c

if isempty(c)
    c=readgenericcsv('essd_ghg_data_gwp100_datasheet.txt',1,tab);
end


% prepare ISOlist
if ischar(ISOlist)
    ISOlist={ISOlist};
end

if nargin==1
    RegionName=[ISOlist{1}];
    if numel(ISOlist)>1
        j=2:max(numel(ISOlist,6))
        RegionName=[RegionName '_' ISOlist{j}];
    end
    if numel(ISOlist)>6
        RegionName=[RegionName '_etc'];
    end
end


% remove the unhappy from ISOlist
removelist=[];
for j=1:numel(ISOlist)
    ISO=ISOlist{j};
    idx=strmatch(ISO,c.ISO);
    if numel(idx)==0
        disp(['removing ' ISO])
        removelist(end+1)=j;
    end
end

ISOlist=ISOlist(setdiff(1:numel(ISOlist),removelist));


% ISOlist to namelist
for j=1:numel(ISOlist)
    ISO=ISOlist{j};
    idx=strmatch(ISO,c.ISO);
    NameList{j}=c.country{idx(1)};
end






clear LUvect Mvect
for j=1:numel(ISOlist);
    ISO=ISOlist{j};
    [M,rows,cols,A,B,OE,IND,T]=AllocateEmissionsNFIRevG(ISO,YYYY);
    LULUCF=SpatializeRegionalLULUCF_Emissions(ISO,YYYY);
    if j==1
        Msum=M;
    else
        Msum=Msum+M;
    end
    Mvect(j)=sum(M(:));
    LUvect(j)=LULUCF;
end
%
clear WriteStruct
WriteStruct.Rows=rows;
for j=1:numel(cols)
    WriteStruct.(cols{j})=Msum(:,j)/1e9;
end
struct2csv([RegionName 'GHGOutputs_NoLULC_' int2str(YYYY) '.csv'],WriteStruct);

clear WriteStruct
WriteStruct.Countries=NameList;
WriteStruct.ISO=ISOlist;
WriteStruct.LUemissions=LUvect;
WriteStruct.NonLUemissions=Mvect;
struct2csv([RegionName 'GHGOutputssummary.csv'],WriteStruct);

disp([' have written out '  RegionName 'GHGOutputs_NoLULC.csv' ' and ' ...
    RegionName 'GHGOutputssummary.csv'])