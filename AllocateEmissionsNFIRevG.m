function [M,rows,cols,A,B,OE,IND,T,E]=AllocateEmissionsNFIRevG(ISO,YYYY);
% AllocateEmissionsNFI "no F***ing indirect"
%
% [M,rows,cols,A,B,OE,IND,T,E]=AllocateEmissionsNFIRevG(ISO,YYYY)

if iscell(ISO)
    ISOlist=ISO;
    ISO=ISOlist{1};
    [M,rows,cols,A,B,OE,IND,T,E]=AllocateEmissionsNFIRevG(ISO,YYYY);
    Mkeep=M;
    for j=2:numel(ISOlist);
    ISO=ISOlist{j}
    [M,rows,cols,A,B,OE,IND,T,E]=AllocateEmissionsNFIRevG(ISO,YYYY);
    Mkeep=Mkeep+M;
    end
    M=Mkeep;
    return;
end



persistent a b c d ee
%persistent sshash_chem sshash_metals sshash_nonres sshash_otheren sshash_otherind sshash_othertrans sshash_rail sshash_residential sshash_road


if isempty(c)
    ParseGHGDataConstantsDefaults
    datadir=DataFilesLocation;
    c=readgenericcsv([datadir 'essd_ghg_data_gwp100_datasheet.txt'],1,tab);
    d=readgenericcsv([datadir 'data_indirect_CO2_countries.txt'],1,tab,1);

subsectorlist=unique(d.subsector_title);

% sshash_chem=uglyhash('Chemicals');
% sshash_metals=uglyhash('Metals');
% sshash_nonres=uglyhash('Non-residential');
% sshash_otheren=uglyhash('Other (energy systems)');
% sshash_otherind=uglyhash('Other (industry)');
% sshash_othertrans=uglyhash('Other (transport)');
% sshash_rail=uglyhash('Rail');
% sshash_residential=uglyhash('Residential');
% sshash_road=uglyhash('Road');
%
% for j=1:numel(d.subsector_title)
%     d.subsector_title_hash(j)=uglyhash(d.subsector_title{j});
% end



end


if nargin==1
    YYYY=2019;
end


InMinxNotEdgarList={
  'ASM',    'ATF',    'BVT',    'CCK',    'CXR',    'FSM',    'GUM',    'MHL',    'MNP', ...
    'MSR',    'MYT',    'NFK',    'NIU',    'NRU',    'PCN',    'TKL',    'TUV',    'UMI', ...
    'VIR',    'WLF'};



c1=subsetofstructureofvectors(c,find(c.year==YYYY));
d1=subsetofstructureofvectors(d,find(d.year==YYYY));

c1=subsetofstructureofvectors(c1,strmatch(ISO,c1.ISO));
d1=subsetofstructureofvectors(d1,strmatch(ISO,d1.ISO));



% % first indirect emissions:
% fid=1
% stlist=unique(d1.sector_title)
% for j=1:4
%     thissector=stlist{j};
%     idx=strmatch(thissector,d1.sector_title);
%
%     sectoremissions=sum(d1.CO2_indirect(idx));
%
%
%
%     sslist=unique(d1.subsector_title(idx));
%     fprintf(fid,'%-25s,%5.4f GtCO2-eq/yr,  %3.2f%%\n',thissector,sum(d1.CO2_indirect(idx)),sum(d1.CO2_indirect(idx))/59.09*100);
%
%
%     for m=1:numel(sslist)
%         idx=strmatch(sslist{m},d1.subsector_title);
%         fprintf(fid,'   %-22s,%5.4f GtCO2-eq/yr,  %3.2f%% \n',sslist{m},sum(d1.CO2_indirect(idx)),sum(d1.CO2_indirect(idx))/59.09*100);
%
%
%     end
%
% end

IE.B.NonRes=d1.CO2_indirect(strmatch('Non-residential',d1.subsector_title));
IE.B.Res=d1.CO2_indirect(strmatch('Residential',d1.subsector_title));
IE.E.Other=sum(d1.CO2_indirect(strmatch('Other (energy systems)',d1.subsector_title,'exact')));
IE.I.Chem=d1.CO2_indirect(strmatch('Chemicals',d1.subsector_title));
IE.I.Metals=d1.CO2_indirect(strmatch('Metals',d1.subsector_title));
IE.I.Other=d1.CO2_indirect(strmatch('Other (industry)',d1.subsector_title));
IE.T.Other=d1.CO2_indirect(strmatch('Other (transport)',d1.subsector_title));
IE.T.Rail=d1.CO2_indirect(strmatch('Rail',d1.subsector_title));
IE.T.Road=d1.CO2_indirect(strmatch('Road',d1.subsector_title));
%


% IE.B.NonRes=d1.CO2_indirect(find(sshash_nonres==d1.subsector_title_hash));
% IE.B.Res=d1.CO2_indirect(find(sshash_residential==d1.subsector_title_hash));
% IE.E.Other=sum(d1.CO2_indirect(find(sshash_otheren==d1.subsector_title_hash)));
% IE.I.Chem=d1.CO2_indirect(sshash_chem==d1.subsector_title_hash);
% IE.I.Metals=d1.CO2_indirect(sshash_metals==d1.subsector_title_hash);
% IE.I.Other=d1.CO2_indirect(sshash_otherind==d1.subsector_title_hash);
% IE.T.Other=d1.CO2_indirect(sshash_othertrans==d1.subsector_title_hash);
% IE.T.Rail=d1.CO2_indirect(sshash_rail==d1.subsector_title_hash);
% IE.T.Road=d1.CO2_indirect(sshash_road==d1.subsector_title_hash);


% sshash_chem=uglyhash('Chemicals');
% sshash_metals=uglyhash('Metals');
% sshash_nonres=uglyhash('Non-residential');
% sshash_otheren=uglyhash('Other (energy systems)');
% sshash_otherind=uglyhash('Other (industry)');
% sshash_othertrans=uglyhash('Other (transport)');
% sshash_rail=uglyhash('Rail');
% sshash_residential=uglyhash('Residential');
% sshash_road=uglyhash('Road');






% need to make sure none of these are zero
if isempty(IE.B.NonRes),IE.B.NonRes=0;end
if isempty(IE.B.Res),IE.B.Res=0;end
if isempty(IE.E.Other),IE.E.Other=0;end
if isempty(IE.I.Chem),IE.I.Chem=0;end
if isempty(IE.I.Metals),IE.I.Metals=0;end
if isempty(IE.I.Other),IE.I.Other=0;end
if isempty(IE.T.Other),IE.T.Other=0;end
if isempty(IE.T.Rail),IE.T.Rail=0;end
if isempty(IE.T.Road),IE.T.Road=0;end



TotalIndirectEnergyFromLamb=IE.B.NonRes+IE.B.Res+IE.E.Other+IE.I.Chem+IE.I.Metals+IE.I.Other+IE.T.Other+IE.T.Rail+IE.T.Road;


% IE = Indirect Energy

% what is indirect energy (from structure c, which comes from
% essd_ghg_data_gwp100_datasheet)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Allocate Indirect Energy %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% here we take the Electricity and heat subsector (from Energy systems
% sector) and allocate that among sectors and gases.
%
% The allocation depends on the Lamb et al allocation to sectors and gases
% One wrinkle is that the sum of Lamb et al stuff adds up to 13.68 whereas
% from Minx et al it should all add up to 13.84.  Discrepancy comes about
% because Lamb et al consider 140 countries, Minx et al consider 230
% countries.  So we need a "CorrectToMinxFactor" which is essentially the
% ratio of 13.84 to 13.68.
%
% HOWEVER ... I'm doing a seprate CMF for each country, so sums might not
% work out.
%
%
% First the CMF
idx=strmatch('Electricity & heat',c1.subsector_title);
TotalIndirectEnergyMinx=sum(c1.GHG(idx));
CorrectToMinxFactor=TotalIndirectEnergyMinx/TotalIndirectEnergyFromLamb;
CMF=CorrectToMinxFactor;


CMF=13.8393/13.6841*1e9;


if TotalIndirectEnergyFromLamb==0
    CMF=1;
end
% And relative allocations are the same across all sectors.  In other
% words, we only have allocation between gases from Minx et al
% Energy;Electricity&heat.  So we apply that to the Indirect breakdown for
% all of the subsectors.
IECO2=sum(c1.CO2(idx));
IECH4=sum(c1.CH4(idx));
IEN2O=sum(c1.N2O(idx));

% now the sectors.

Denom=(IECO2+IECH4+IEN2O);

if Denom==0
    % cheesy - keep it 1 just so it converges.  indirect CO2 will be 0.
    Denom=1;
end

% buildings
nonresindirectCO2 = IE.B.NonRes*CMF*(IECO2)/Denom;
resindirectCO2 = IE.B.Res*CMF*(IECO2)/Denom;;
nonresindirectCH4 = IE.B.NonRes*CMF*(IECH4)/Denom;;
resindirectCH4 = IE.B.Res*CMF*(IECH4)/Denom;
nonresindirectN2O = IE.B.NonRes*CMF*(IEN2O)/Denom;
resindirectN2O = IE.B.Res*CMF*(IEN2O)/Denom;

% now all the others
ensystemsotherCO2=IE.E.Other*CMF*(IECO2)/Denom;
industrychemCO2=IE.I.Chem*CMF*(IECO2)/Denom;
industrymetCO2=IE.I.Metals*CMF*(IECO2)/Denom;
industryotherCO2=IE.I.Other*CMF*(IECO2)/Denom;
transportOtherCO2=IE.T.Other*CMF*(IECO2)/Denom;
transportRailCO2=IE.T.Rail*CMF*(IECO2)/Denom;
transportRoadCO2=IE.T.Road*CMF*(IECO2)/Denom;

ensystemsotherCH4=IE.E.Other*CMF*(IECH4)/Denom;
industrychemCH4=IE.I.Chem*CMF*(IECH4)/Denom;
industrymetCH4=IE.I.Metals*CMF*(IECH4)/Denom;
industryotherCH4=IE.I.Other*CMF*(IECH4)/Denom;
transportOtherCH4=IE.T.Other*CMF*(IECH4)/Denom;
transportRailCH4=IE.T.Rail*CMF*(IECH4)/Denom;
transportRoadCH4=IE.T.Road*CMF*(IECH4)/Denom;

ensystemsotherN2O=IE.E.Other*CMF*(IEN2O)/Denom;
industrychemN2O=IE.I.Chem*CMF*(IEN2O)/Denom;
industrymetN2O=IE.I.Metals*CMF*(IEN2O)/Denom;
industryotherN2O=IE.I.Other*CMF*(IEN2O)/Denom;
transportOtherN2O=IE.T.Other*CMF*(IEN2O)/Denom;
transportRailN2O=IE.T.Rail*CMF*(IEN2O)/Denom;
transportRoadN2O=IE.T.Road*CMF*(IEN2O)/Denom;


transportElectricityAllCO2=transportOtherCO2+transportRailCO2+transportRoadCO2;
transportElectricityAllCH4=transportOtherCH4+transportRailCH4+transportRoadCH4;
transportElectricityAllN2O=transportOtherN2O+transportRailN2O+transportRoadN2O;



%%%%%%%%%%%%%%%%%
%    AFOLU      %
%%%%%%%%%%%%%%%%%

% first put together AFOLU
% rows =
% Biomass burning (CH4, N2O)
% Managed soils and pasture (CO2, N2O)
% Manure management (N2O, CH4)
% Enteric Fermentation (CH4)
% Rice cultivation (CH4)
% Synthetic fertilizer application (N2O)


idx=strmatch('"Biomass burning (CH4, N2O)"',c1.subsector_title);
afolu.bb.CO2=c1.CO2(idx);
afolu.bb.CH4=c1.CH4(idx);
afolu.bb.N2O=c1.N2O(idx);
afolu.bb.Fgas=c1.Fgas(idx);

idx=strmatch('"Managed soils and pasture (CO2, N2O)"',c1.subsector_title);
afolu.ms.CO2=c1.CO2(idx);
afolu.ms.CH4=c1.CH4(idx);
afolu.ms.N2O=c1.N2O(idx);
afolu.ms.Fgas=c1.Fgas(idx);

idx=strmatch('"Manure management (N2O, CH4)"',c1.subsector_title);
afolu.mm.CO2=c1.CO2(idx);
afolu.mm.CH4=c1.CH4(idx);
afolu.mm.N2O=c1.N2O(idx);
afolu.mm.Fgas=c1.Fgas(idx);

idx=strmatch('Enteric',c1.subsector_title);
afolu.ef.CO2=c1.CO2(idx);
afolu.ef.CH4=c1.CH4(idx);
afolu.ef.N2O=c1.N2O(idx);
afolu.ef.Fgas=c1.Fgas(idx);

idx=strmatch('Rice cultivation',c1.subsector_title);
afolu.rc.CO2=c1.CO2(idx);
afolu.rc.CH4=c1.CH4(idx);
afolu.rc.N2O=c1.N2O(idx);
afolu.rc.Fgas=c1.Fgas(idx);

idx=strmatch('Synth',c1.subsector_title);
afolu.sf.CO2=c1.CO2(idx);
afolu.sf.CH4=c1.CH4(idx);
afolu.sf.N2O=c1.N2O(idx);
afolu.sf.Fgas=c1.Fgas(idx);


afolu=replaceemptywith0(afolu);


A.CO2=[0 0 0 afolu.bb.CO2
    0 0 0 afolu.ms.CO2
    0 0 0 0
    0 0 0 0
    0 0 0 0
    0 0 0 0];

A.CH4=[ 0 0 0 afolu.bb.CH4
    0 0 0 afolu.ms.CH4
    0 0 0 afolu.mm.CH4
    0 0 0 afolu.ef.CH4
    0 0 0 afolu.rc.CH4
    0 0 0 afolu.sf.CH4];

A.N2O=[ 0 0 0 afolu.bb.N2O
    0 0 0 afolu.ms.N2O
    0 0 0 afolu.mm.N2O
    0 0 0 afolu.ef.N2O
    0 0 0 afolu.rc.N2O
    0 0 0 afolu.sf.N2O];

A.Fgas=[ 0 0 0 afolu.bb.Fgas
    0 0 0 afolu.ms.Fgas
    0 0 0 afolu.mm.Fgas
    0 0 0 afolu.ef.Fgas
    0 0 0 afolu.rc.Fgas
    0 0 0 afolu.sf.Fgas];



%%%%%%%%%%%%%%%%%
%   BUILDINGS   %
%%%%%%%%%%%%%%%%%

% first need to calculate non res


idx=strmatch('Non-C',c1.subsector_title);
buildings.nc.CO2=c1.CO2(idx);
buildings.nc.CH4=c1.CH4(idx);
buildings.nc.N2O=c1.N2O(idx);
buildings.nc.Fgas=c1.Fgas(idx);

idx=strmatch('Non-r',c1.subsector_title);
buildings.nr.CO2=c1.CO2(idx);
buildings.nr.CH4=c1.CH4(idx);
buildings.nr.N2O=c1.N2O(idx);
buildings.nr.Fgas=c1.Fgas(idx);

idx=strmatch('Res',c1.subsector_title);
buildings.re.CO2=c1.CO2(idx);
buildings.re.CH4=c1.CH4(idx);
buildings.re.N2O=c1.N2O(idx);
buildings.re.Fgas=c1.Fgas(idx);

buildings=replaceemptywith0(buildings);

B.CO2=[0 0 0 0
    0 buildings.nr.CO2 0 0
    0 buildings.re.CO2 0 0];

B.CH4=[0 0 0 0
    0 buildings.nr.CH4 0 0
    0 buildings.re.CH4 0 0];

B.N2O=[0 0 0 0
    0 buildings.nr.N2O 0 0
    0 buildings.re.N2O 0 0];

B.Fgas=[0 0 buildings.nc.Fgas 0
    0 0 0 0
    0 0 0 0];




%%%%%%%%%%%%%%%%%%
%   Other Energy %
%%%%%%%%%%%%%%%%%%
idx=strmatch('Coal',c1.subsector_title);
otherenergy.cmf.CO2=c1.CO2(idx);
otherenergy.cmf.CH4=c1.CH4(idx);
otherenergy.cmf.N2O=c1.N2O(idx);
otherenergy.cmf.Fgas=c1.Fgas(idx);

idx=strmatch('Oil',c1.subsector_title);
otherenergy.ogf.CO2=c1.CO2(idx);
otherenergy.ogf.CH4=c1.CH4(idx);
otherenergy.ogf.N2O=c1.N2O(idx);
otherenergy.ogf.Fgas=c1.Fgas(idx);

idx=strmatch('Other (energy',c1.subsector_title);
otherenergy.oth.CO2=c1.CO2(idx);
otherenergy.oth.CH4=c1.CH4(idx);
otherenergy.oth.N2O=c1.N2O(idx);
otherenergy.oth.Fgas=c1.Fgas(idx);

idx=strmatch('Petroleum',c1.subsector_title);
otherenergy.prf.CO2=c1.CO2(idx);
otherenergy.prf.CH4=c1.CH4(idx);
otherenergy.prf.N2O=c1.N2O(idx);
otherenergy.prf.Fgas=c1.Fgas(idx);
otherenergy=replaceemptywith0(otherenergy);

OE.CO2=[0               otherenergy.cmf.CO2 0 0
    0                   otherenergy.ogf.CO2 0 0
    0   otherenergy.oth.CO2 0 0
    0                   otherenergy.prf.CO2 0 0];

OE.CH4=[0               otherenergy.cmf.CH4 0 0
    0                   otherenergy.ogf.CH4 0 0
    0                   otherenergy.oth.CH4 0 0
    0                   otherenergy.prf.CH4 0 0];


OE.N2O=[0               otherenergy.cmf.N2O 0 0
    0                   otherenergy.ogf.N2O 0 0
    0                   otherenergy.oth.N2O 0 0
    0                   otherenergy.prf.N2O 0 0];


OE.Fgas=[0               otherenergy.cmf.Fgas 0 0
    0                   otherenergy.ogf.Fgas 0 0
    0                   otherenergy.oth.Fgas 0 0
    0                   otherenergy.prf.Fgas 0 0];

%%%%%%%%%%%%%%
% Industry   %
%%%%%%%%%%%%%%
% industry is tricky because need a further allocation step between
% fossil/process for CO2.   These numbers can be inferred from the data in
% GHG Sources_RevE
%
PfracCement=0.9849/(0.563087452+0.984912548);
PfracChem=1.485640051/(0.849359949+1.485640051);
PfracMetals=0.39112883/(2.64487117+0.39112883);
PfracOther=0.317466612/(3.066533388+0.317466612);







idx=strmatch('Cem',c1.subsector_title);
industry.cem.CO2=c1.CO2(idx);
industry.cem.CH4=c1.CH4(idx);
industry.cem.N2O=c1.N2O(idx);
industry.cem.Fgas=c1.Fgas(idx);

idx=strmatch('Chem',c1.subsector_title);
industry.chem.CO2=c1.CO2(idx);
industry.chem.CH4=c1.CH4(idx);
industry.chem.N2O=c1.N2O(idx);
industry.chem.Fgas=c1.Fgas(idx);

idx=strmatch('Met',c1.subsector_title);
industry.met.CO2=c1.CO2(idx);
industry.met.CH4=c1.CH4(idx);
industry.met.N2O=c1.N2O(idx);
industry.met.Fgas=c1.Fgas(idx);

idx=strmatch('Other (industry)',c1.subsector_title);
industry.oth.CO2=c1.CO2(idx);
industry.oth.CH4=c1.CH4(idx);
industry.oth.N2O=c1.N2O(idx);
industry.oth.Fgas=c1.Fgas(idx);

% industry.wa.CO2=c1.CO2(idx);
% industry.wa.CH4=c1.CH4(idx);
% industry.wa.N2O=c1.N2O(idx);
% industry.wa.Fgas=c1.Fgas(idx);
%

% Here in Rev G, we are breaking out Industry;waste into three subsectors.
%

%[CO2eqSolidWaste,SolidWaste]=getEdgarData(ISO,'CO2','Incineration and Open Burning of Waste',YYYY);
idx=strmatch('Waste',c1.subsector_title);

industry.wwt.CO2=0;
industry.btsw.CO2=0;
industry.swd.CO2=c1.CO2(idx);
%industry.swd.CO2=c1.CO2(idx)*SolidWaste/SolidWaste; % This would be
%consistent way to code it - but emissions can only go here.

idx=strmatch('Waste',c1.subsector_title);

if numel(strmatch(ISO,InMinxNotEdgarList))==1
    [CH4BioTreatSW,CH4Wastewater,CH4SolidWaste,CH4Incineration,...
        N2OBioTreatSW,N2OWastewater,N2OIncineration]=GetRegionalEdgarWasteAllocation(ISO,YYYY);
else
    [CO2eqBioTreatSW,CH4BioTreatSW]=getEdgarData(ISO,'CH4','Biological Treatment of Solid Waste',YYYY);
    [CO2eqWastewater,CH4Wastewater]=getEdgarData(ISO,'CH4','Wastewater Treatment and Discharge',YYYY);
    [CO2eqSolidWaste,CH4SolidWaste]=getEdgarData(ISO,'CH4','Solid Waste Disposal',YYYY);
    [CO2eqIncineration,CH4Incineration]=getEdgarData(ISO,'CH4','Incineration and Open Burning of Waste',YYYY);
    [CO2eqBioTreatSW,N2OBioTreatSW]=getEdgarData(ISO,'N2O','Biological Treatment of Solid Waste',YYYY);
    [CO2eqWastewater,N2OWastewater]=getEdgarData(ISO,'N2O','Wastewater Treatment and Discharge',YYYY);
    %[CO2eqSolidWaste,N2OSolidWaste]=getEdgarData(ISO,'N2O','Solid Waste Disposal',YYYY);
    [CO2eqIncineration,N2OIncineration]=getEdgarData(ISO,'N2O','Incineration and Open Burning of Waste',YYYY);
end
N2OSolidWaste=0;  % doesn't exist in EDGAR N2O


industry.wwt.CH4=c1.CH4(idx)*(CH4Wastewater)/(CH4BioTreatSW+CH4Wastewater+CH4SolidWaste+CH4Incineration);
industry.swd.CH4=c1.CH4(idx)*(CH4SolidWaste)/(CH4BioTreatSW+CH4Wastewater+CH4SolidWaste+CH4Incineration);
industry.btsw.CH4=c1.CH4(idx)*(CH4BioTreatSW+CH4Incineration)/(CH4BioTreatSW+CH4Wastewater+CH4SolidWaste+CH4Incineration);





idx=strmatch('Waste',c1.subsector_title);
industry.wwt.N2O=c1.N2O(idx)*(N2OWastewater)/(N2OBioTreatSW+N2OWastewater+N2OSolidWaste+N2OIncineration);
industry.swd.N2O=c1.N2O(idx)*(N2OSolidWaste)/(N2OBioTreatSW+N2OWastewater+N2OSolidWaste+N2OIncineration);
industry.btsw.N2O=c1.N2O(idx)*(N2OBioTreatSW+N2OIncineration)/(N2OBioTreatSW+N2OWastewater+N2OSolidWaste+N2OIncineration);



industry=replaceemptywith0(industry);



IND.CO2=[0               industry.cem.CO2*(1-PfracCement) industry.cem.CO2*(PfracCement) 0
    0                   industry.chem.CO2*(1-PfracChem) industry.chem.CO2*(PfracChem) 0
    0   industry.met.CO2*(1-PfracMetals)  industry.met.CO2*(PfracMetals) 0
    0                   industry.oth.CO2*(1-PfracOther) industry.oth.CO2*(PfracOther) 0
    0 0 0 0
        0  0  industry.swd.CO2 0
    0 0 0 0];


IND.CH4= [0  0             industry.cem.CH4 0
    0 0                  industry.chem.CH4 0
    0 0  industry.met.CH4 0
    0 0  industry.oth.CH4 0
    0 0                  industry.btsw.CH4 0
    0 0                  industry.swd.CH4 0
    0 0                  industry.wwt.CH4 0 ];


IND.N2O= [0  0             industry.cem.N2O 0
    0 0                  industry.chem.N2O 0
    0 0  industry.met.N2O 0
    0 0  industry.oth.N2O 0
    0 0                  industry.btsw.N2O 0
    0 0                  industry.swd.N2O 0
    0 0                  industry.wwt.N2O 0 ];

IND.Fgas= [0  0             industry.cem.Fgas 0
    0 0                  industry.chem.Fgas 0
    0 0  industry.met.Fgas 0
    0 0  industry.oth.Fgas 0
    0 0                  0 0
    0 0                  0 0
    0 0                  0 0 ];



%%%%%%%%%%%%%%%%%%%%%%%%
%   Electricity        %
%%%%%%%%%%%%%%%%%%%%%%%%

E.CO2=[nonresindirectCO2 0 0 0
    resindirectCO2 0 0 0
    ensystemsotherCO2 0 0 0
    industrychemCO2 0 0 0
    industrymetCO2 0 0 0
    industryotherCO2 0 0 0
    transportOtherCO2 0 0 0
    transportRailCO2 0 0 0
    transportRoadCO2 0 0 0];

E.CH4=[nonresindirectCH4 0 0 0
    resindirectCH4 0 0 0
    ensystemsotherCH4 0 0 0
    industrychemCH4 0 0 0
    industrymetCH4 0 0 0
    industryotherCH4 0 0 0
    transportOtherCH4 0 0 0
    transportRailCH4 0 0 0
    transportRoadCH4 0 0 0];

E.N2O=[nonresindirectN2O 0 0 0
    resindirectN2O 0 0 0
    ensystemsotherN2O 0 0 0
    industrychemN2O 0 0 0
    industrymetN2O 0 0 0
    industryotherN2O 0 0 0
    transportOtherN2O 0 0 0
    transportRailN2O 0 0 0
    transportRoadN2O 0 0 0];


%%%%%%%%%%%%%%%%%%
% Transportation %
%%%%%%%%%%%%%%%%%%

idx=strmatch('Dom',c1.subsector_title);
transport.da.CO2=c1.CO2(idx);
transport.da.CH4=c1.CH4(idx);
transport.da.N2O=c1.N2O(idx);
transport.da.Fgas=c1.Fgas(idx);


idx=strmatch('Inland Shipping',c1.subsector_title);
transport.inls.CO2=c1.CO2(idx);
transport.inls.CH4=c1.CH4(idx);
transport.inls.N2O=c1.N2O(idx);
transport.inls.Fgas=c1.Fgas(idx);

idx=strmatch('International Aviation',c1.subsector_title);
transport.ia.CO2=c1.CO2(idx);
transport.ia.CH4=c1.CH4(idx);
transport.ia.N2O=c1.N2O(idx);
transport.ia.Fgas=c1.Fgas(idx);

idx=strmatch('International Shipping',c1.subsector_title);
transport.ints.CO2=c1.CO2(idx);
transport.ints.CH4=c1.CH4(idx);
transport.ints.N2O=c1.N2O(idx);
transport.ints.Fgas=c1.Fgas(idx);

idx=strmatch('Other (transport)',c1.subsector_title);
transport.ot.CO2=c1.CO2(idx);
transport.ot.CH4=c1.CH4(idx);
transport.ot.N2O=c1.N2O(idx);
transport.ot.Fgas=c1.Fgas(idx);

idx=strmatch('Rail',c1.subsector_title);
transport.ra.CO2=c1.CO2(idx);
transport.ra.CH4=c1.CH4(idx);
transport.ra.N2O=c1.N2O(idx);
transport.ra.Fgas=c1.Fgas(idx);

idx=strmatch('Road',c1.subsector_title);
transport.ro.CO2=c1.CO2(idx);
transport.ro.CH4=c1.CH4(idx);
transport.ro.N2O=c1.N2O(idx);
transport.ro.Fgas=c1.Fgas(idx);


transport=replaceemptywith0(transport);

T.CO2= [0               transport.da.CO2 0 0
    0                   transport.inls.CO2 0 0
    0                   transport.ia.CO2 0 0
    0                   transport.ints.CO2 0 0
    0                   transport.ot.CO2 0 0
    0                   transport.ra.CO2 0 0
    0                  transport.ro.CO2 0 0];


T.N2O= [0               transport.da.N2O 0 0
    0                   transport.inls.N2O 0 0
    0                   transport.ia.N2O 0 0
    0                   transport.ints.N2O 0 0
    0                   transport.ot.N2O 0 0
    0                   transport.ra.N2O 0 0
    0                  transport.ro.N2O 0 0];



T.CH4= [0               transport.da.CH4 0 0
    0                   transport.inls.CH4 0 0
    0                   transport.ia.CH4 0 0
    0                   transport.ints.CH4 0 0
    0                   transport.ot.CH4 0 0
    0                   transport.ra.CH4 0 0
    0                  transport.ro.CH4 0 0];

T.Fgas= [0               transport.da.Fgas 0 0
    0                   transport.inls.Fgas 0 0
    0                   transport.ia.Fgas 0 0
    0                   transport.ints.Fgas 0 0
    0                   transport.ot.Fgas 0 0
    0                   transport.ra.Fgas 0 0
    0                  transport.ro.Fgas 0 0];


%Now make a big matrix M

M=zeros(36,16);

%Rows correspond to

rows={
    'afolu_biomass',...
    'afolu_managedsoils',...
    'afolu_manuremanagement',...
    'afolu_entericfermentation',...
    'afolu_ricecultivation',...
    'afolu_syntheticfert',...
    'buildings_nonCO2',...
    'buildings_nonres',...
    'buildings_res',...
    'electricity_buildings_non_res',...
    'electricity_buildings_res',...
    'electricity_otherenergy',...
    'electricity_industry_chem',...
    'electricity_industry_other',...
    'electricity_industry_waste',...
    'electricity_other',...
    'electricity_rail',...
    'electricity_road',...
    'otherenergy_coalfugitive',...
    'otherenergy_oilfugitive',...
    'otherenergy_other',...
    'otherenergy_refining',...
    'industry_cement',...
    'industry_chemical',...
    'industry_metals',...
    'industry_other',...
    'industry_burningtreatingsolidwaste',...
    'industry_solidwastedisposal',...
    'industry_wastewatertreatment',...
    'transport_domesticaviation',...
    'transport_inlandshipping',...
    'transport_internationalaviation',...
    'transport_internationalshipping',...
    'transport_other',...
    'transport_rail',...
    'transport_road'};
% 'afolu_LULUCF',...

cols ={
    'CO2_elec',...
    'CO2_fossil',...
    'CO2_process',...
    'CO2_biogenic',...
    'CH4_elec',...
    'CH4_fossil',...
    'CH4_process',...
    'CH4_biogenic',...
    'N2O_elec',...
    'N2O_fossil',...
    'N2O_process',...
    'N2O_biogenic',...
    'Fgas_elec',...
    'Fgas_fossil',...
    'Fgas_process',...
    'Fgas_biogenic'};


M(1:6,1:4)=A.CO2;
M(1:6,5:8)=A.CH4;
M(1:6,9:12)=A.N2O;
M(1:6,13:16)=A.Fgas;

ii=7:9;
M(ii,1:4)=B.CO2;
M(ii,5:8)=B.CH4;
M(ii,9:12)=B.N2O;
M(ii,13:16)=B.Fgas;

ii=10:18;
M(ii,1:4)=E.CO2;
M(ii,5:8)=E.CH4;
M(ii,9:12)=E.N2O;
M(ii,13:16)=0;

ii=19:22;
M(ii,1:4)=OE.CO2;
M(ii,5:8)=OE.CH4;
M(ii,9:12)=OE.N2O;
M(ii,13:16)=OE.Fgas;

ii=23:29;
M(ii,1:4)=IND.CO2;
M(ii,5:8)=IND.CH4;
M(ii,9:12)=IND.N2O;
M(ii,13:16)=IND.Fgas;

ii=30:36;
M(ii,1:4)=T.CO2;
M(ii,5:8)=T.CH4;
M(ii,9:12)=T.N2O;
M(ii,13:16)=T.Fgas;











































