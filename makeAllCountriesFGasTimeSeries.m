
ParseGHGDataConstantsDefaults

warning('this code is really slow - not very efficient at all')
pause(1)

geo=load([GADMFilesLocation 'gadm41_level0raster5minVer1.mat'])
ISOlist=geo.gadm0codes;

CH4Fugitiveemissionsmap=datablank;
CH4Solidemissionsmap=datablank;
CH4WWemissionsmap=datablank;
CH4WW_PercentPerYearChange_map=datablank;
CH4WW_percapita_PercentPerYearChange_map=datablank;
CH4WW_percapita2019=datablank;


[M, rows, cols, A, B, OE, IND, T]=AllocateEmissionsNFIRevG('USA',2019);
icf=strmatch('otherenergy_coalfugitive',rows);
iof=strmatch('otherenergy_oilfugitive',rows);
iburn=strmatch('industry_burningtreatingsolidwaste',rows);
itreat=strmatch('industry_solidwastedisposal',rows);
iwastewater=strmatch('industry_wastewatertreatment',rows);


%%
yrvect=1970:2019;
for j=1:numel(ISOlist)
    
    for jyr=1:numel(yrvect);
        YYYY=yrvect(jyr);
        ISO=ISOlist{j}
        
        [M, rows, cols, A, B, OE, IND, T]=AllocateEmissionsNFIRevG(ISO,YYYY);
        
        FgasEmissions(jyr,j)=sum(sum(M(:,13:16)));
        TotEmissions(jyr,j)=sum(sum(M(:,:)));
                
    end
    
end
figure,plot(yrvect,sum(FgasEmissions,2)/1e6)
grid on
xlabel('year')
ylabel('Mt CO_2eq')
title(['F gas emissions (Minx et al)'])
fattenplot

figure,plot(yrvect,sum(FgasEmissions,2)./sum(TotEmissions,2)*100)
grid on
xlabel('year')
ylabel('%')
title(['F gas emissions as fraction of total emissions (Minx et al)'])
fattenplot



