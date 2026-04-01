function [LUCemissions,version]=getLULUC(ISO,YYYY);
%  return GCB LUC emissions
% 
% 
% ISOlist=MinxCountriesList;
%  YYYYvect=2015:2024;
% clear y
% for jyr=1:10;
% YYYY=YYYYvect(jyr);
% clear LUCemissionsvect 
%
% for j=1:numel(ISOlist);
%     ISO=ISOlist{j};
%    [LUCemissionsvect(j)]=getLULUC(ISO,YYYY);
% end
% y(jyr)=sum(LUCemissionsvect);
% end
    

persistent aOSCAR aBLUE aLUCE iso_lookup
if isempty(aLUCE)

    aOSCAR = importNationalLUCfromGCB("~/DataProducts/ext/GlobalCarbonBudget/GCB2025/National_LandUseChange_Carbon_Emissions_2025v0.2.xlsx", "OSCAR", [9, Inf]);
    aBLUE = importNationalLUCfromGCB("~/DataProducts/ext/GlobalCarbonBudget/GCB2025/National_LandUseChange_Carbon_Emissions_2025v0.2.xlsx", "BLUE", [9, Inf]);
    aLUCE  = importNationalLUCfromGCB("~/DataProducts/ext/GlobalCarbonBudget/GCB2025/National_LandUseChange_Carbon_Emissions_2025v0.2.xlsx", "LUCE", [9, Inf]);
    countryfieldnamestoISOcodes

end

version = 'GCB2025v0.2';


% test that things more or less work


% idx = strcmp(iso_lookup(:,1), 'France');
% iso = iso_lookup{idx, 2};  % returns 'FRA'
% idx = strcmp(iso_lookup(:,2), 'FRA');
% name = iso_lookup{idx, 1};  % returns 'France'


idx = find(strcmp(iso_lookup(:,2), ISO));

if isempty(idx)
    LUCemissions=0;
else
    name = iso_lookup{idx, 1};  % returns 'France'

    y1=aBLUE.(name);
    y2=aOSCAR.(name);
    y3=aLUCE.(name);

    yearvect=aBLUE.unit_TgC_year;

    idx=yearvect==YYYY;


    LUCemissions=(y1(idx)+y2(idx)+y3(idx))*3.667/3;

end