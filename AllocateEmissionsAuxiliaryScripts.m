%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  code to test that can reproduce done-by-hand excel spreadsheet    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


c=readgenericcsv('essd_ghg_data_gwp100_datasheet.txt',1,tab);
ISOlist=unique(c.ISO);
ISOlistWorld=unique(c.ISO);
for j=1:numel(ISOlist)
    idx=strmatch(ISOlist{j},c.ISO);
    NameList{j}=c.country{idx(1)};
end
YYYY=2019
%%

clear LUvect Mvect
for j=1:numel(ISOlist);
    
     ISO=ISOlist{j};
    [M,rows,cols,A,B,OE,IND,T]=AllocateEmissionsNFI(ISO,YYYY);
     LULUCF=SpatializeRegionalLULUCF_Emissions(ISO);
    if numel(find(isnan(M)))>0
        ISO
        keyboard
    end
    
    if j==1
        Msum=M;
    else
        Msum=Msum+M;        
    end
    Mvect(j)=sum(M(:));
    LUvect(j)=LULUCF;
    
end


%%
clear WriteStruct
WriteStruct.Rows=rows;

for j=1:numel(cols)
    WriteStruct.(cols{j})=Msum(:,j)/1e9;
end
struct2csv('GHGOutputs_NoLULC.csv',WriteStruct);

clear WriteStruct
WriteStruct.Countries=NameList;
WriteStruct.ISO=ISOlist;
WriteStruct.LUemissions=LUvect;
WriteStruct.NonLUemissions=Mvect;
struct2csv('GHGOutputssummaryByCountry.csv',WriteStruct);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% code to make a .csv for every country and sector
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
b=readgenericcsv('essd_lulucf_data_datasheet.txt',1,tab);
b=subsetofstructureofvectors(b,find(b.year==2019));
c=readgenericcsv('essd_ghg_data_gwp100_datasheet.txt',1,tab);
%%
ISOlist=unique(c.ISO);
ISOlistWorld=unique(c.ISO);
for j=1:numel(ISOlist)
    idx=strmatch(ISOlist{j},c.ISO);
    NameList{j}=c.country{idx(1)};
    NameListNoComma{j}=strrep(c.country{idx(1)},',','_');
    regionAR6_6{j}=c.region_ar6_6{idx(1)};
    regionAR6_10{j}=c.region_ar6_10{idx(1)};
    regionAR6_22{j}=c.region_ar6_22{idx(1)};
    regionAR6_dev{j}=c.region_ar6_dev{idx(1)};
    OECD{j}=ISOtoOECD(ISOlist{j},2019);
end
YYYY=2019
%
%%
clear LUvect Mvect
clear WriteStruct
counter = 0;
for j=1:numel(ISOlist);
    
    ISO=ISOlist{j};
    [M,rows,cols,A,B,OE,IND,T]=AllocateEmissionsNFI(ISO,YYYY);
    LULUCF=SpatializeRegionalLULUCF_Emissions(ISO);
 
    counter=counter+1;
    WriteStruct.Countries{counter}=NameListNoComma{j};
    WriteStruct.ISO{counter}=ISOlist{j};
    WriteStruct.RegionAR6_6{counter}=regionAR6_6{j};
    WriteStruct.RegionAR6_10{counter}=regionAR6_10{j};
    WriteStruct.RegionAR6_22{counter}=regionAR6_22{j};
    WriteStruct.RegionAR6_dev{counter}=regionAR6_dev{j};
    WriteStruct.OECD{counter}=ISOtoOECD(ISOlist{j},2019);
    Mthin=sum(M,2);
    
    for m=1:numel(rows)
        WriteStruct.(rows{m}){counter}=Mthin(m);
    end

    WriteStruct.LULUCF_CheesyAllocation{counter}=LULUCF;
    
    idx=strmatch(regionAR6_10{j},b.region_ar6_10);
    WriteStruct.LULUCF_AR6_10_Aggregated{counter}=b.mean(idx);
end
struct2csv('GHGOutputs_AllCountries_AllSectors_2019.csv',WriteStruct);

%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     code to output region-specific GHG emissions tables       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% South Asia
clear ISOlist NameList
load([iddstring '/misc/ContinentOutlineData.mat'])
idx=strmatch('Southern Asia',UNREGION1)

idx=idx([1:4 6:end])
for j=1:numel(idx)
    S=getcountrycode(NAME_FAO{idx(j)})
    ISOlist{j}=S.GADM_ISO;
    NameList{j}=S.GADM_NAME_FAO;
end

ParseAndDisplayEmissions_RegionSpecificTables(ISOlist,'SouthAsia',2019)
ParseAndDisplayEmissions_WasteTimeSeries(ISOlist)



%% SSA
clear ISOlist NameList M Msum
[ii,NameList]=continentoutline({'Eastern Africa','Western Africa','Southern Africa','Middle Africa'});
NameList{12}='reunion';
NameList{end+1}='Sudan';
for j=1:numel(NameList);
    %S=getcountrycode(NameList{j})
    S=StandardCountryNames(NameList{j});
    ISOlist{j}=S.GADM_ISO;
    NameList{j}=S.GADM_NAME_FAO;
end

ParseAndDisplayEmissions_RegionSpecificTables(ISOlist,'SSA',2019)
ParseAndDisplayEmissions_WasteTimeSeries(ISOlist,'World')
ParseAndDisplayEmissions_AllSectorTimeSeries(ISOlist,'SSA')

ParseAndDisplayEmissions_AllSectorTimeSeries(ISOlistWorld,'World')
ParseAndDisplayEmissions_WasteTimeSeries(ISOlistWorld,'World')

%% SSA
clear ISOlist NameList M Msum
[ii,NameList]=continentoutline({'Africa'});
NameList{39}='reunion';
for j=1:numel(NameList);
    %S=getcountrycode(NameList{j})
    S=StandardCountryNames(NameList{j});
    ISOlist{j}=S.GADM_ISO;
    NameList{j}=S.GADM_NAME_FAO;
end

ParseAndDisplayEmissions_RegionSpecificTables(ISOlist,'AllAfrica',2019)
ParseAndDisplayEmissions_WasteTimeSeries(ISOlist,'World')
ParseAndDisplayEmissions_AllSectorTimeSeries(ISOlist,'SSA')

ParseAndDisplayEmissions_AllSectorTimeSeries(ISOlistWorld,'World')
ParseAndDisplayEmissions_WasteTimeSeries(ISOlistWorld,'World')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Europe
%        code to make timeseries of all Minx sectors                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

clear ISOlist NameList M Msum
[ii,NameList]=continentoutline({'Europe'});
NameList{12}='reunion';
NameList{end+1}='Sudan';
for j=1:numel(NameList);
    %S=getcountrycode(NameList{j})
    S=StandardCountryNames(NameList{j});
    ISOlist{j}=S.GADM_ISO;
    NameList{j}=S.GADM_NAME_FAO;
end

ISOlist=ISOlist([1:17 19:41 43:44]);
ParseAndDisplayEmissions_RegionSpecificTables(ISOlist,'Europe',2019)

removing ... 
    
notEU= {{'ALB'}    {'AND'}   {'BEL'}    {'BIH'} {'REU'}    {'ISL'}    {'IMN'} {'LIE'}    {'LTU'} {'MKD'}   {'MDA'} {'RUS'} ...
 {'UKR'} {'SRB'} };

for j=1:numel(notEU)
    tmp=char(notEU{j})

idx=strmatch(tmp,ISOlist);
ISOlist=ISOlist(setdiff(1:numel(ISOlist),idx));
end

ISOlist
ParseAndDisplayEmissions_RegionSpecificTables(ISOlist,'EU',2019)


Austria
Belgium
Bulgaria
Croatia
Cyprus
Czech Republic
Denmark
Estonia
Finland
France
Germany
Greece
Hungary
Ireland
Italy
Latvia
Lithuania
Luxembourg
Malta
Netherlands
Poland
Portugal
Romania
Slovakia
Slovenia
Spain
Sweden
