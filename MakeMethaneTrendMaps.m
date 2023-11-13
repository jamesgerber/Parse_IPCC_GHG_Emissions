%% Section to make a plot for each row of M matrix
ParseGHGDataConstantsDefaults


geo=load([GADMFilesLocation 'gadm41_level0raster5minVer1.mat']);
ISOlist=geo.gadm0codes;

warning('this code is really slow - not very efficient at all')
warning('swapping in just a few countries as a test')
pause(1)
ISOlist={'USA','CAN','CHN','IND'}



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


makemaps=0;

if makemaps==1
    
    for j=1:length(ISOlist)
        ISO=ISOlist{j}
        
        [M, rows, cols, A, B, OE, IND, T]=AllocateEmissionsNFIRevG(ISO,2019);
        
        LULUCF=SpatializeRegionalLULUCF_Emissions(ISO);
        
        ii=geo.raster0==j;
        
        CH4Fugitive=sum(sum(M([icf iof],5:8)));
        CH4Solid=sum(sum(M([iburn itreat],5:8)));
        CH4WW=sum(sum(M([iwastewater],5:8)));
        
        CH4Fugitiveemissionsmap(ii)=sum(CH4Fugitive);
        CH4Solidemissionsmap(ii)=sum(CH4Solid);
        CH4WWemissionsmap(ii)=sum(CH4WW);
        
        countrysumCH4WW(j)=CH4WW;
    end
    
    
    clear NSS
    NSS.caxis=0.99;
    NSS.title=['Ratio Fugitive emissions to Wastewater emissions (CH4)'];
    NSS.filename='tmp';
    NSS.plotstates='off';
    NSS.sink='nonagplaces';
    NSS.longlatlines='off';
    %NSS.cmap='purple_blue_green';
    [OS]=nsg(CH4Fugitiveemissionsmap./CH4WWemissionsmap,NSS);
    maketransparentoceans_noant_nogridlinesnostates_removeislands('tmp.png',['RatioFugitiveToWasteWater'],.9*[1 1 1]);
    
    clear NSS
    NSS.caxis=0.99;
    NSS.title=['Ratio Solid emissions to Wastewater emissions (CH4)'];
    NSS.filename='tmp';
    NSS.plotstates='off';
    NSS.sink='nonagplaces';
    NSS.longlatlines='off';
    %NSS.cmap='purple_blue_green';
    [OS]=nsg(CH4Solidemissionsmap./CH4WWemissionsmap,NSS);
    maketransparentoceans_noant_nogridlinesnostates_removeislands('tmp.png',['RatioSolidToWasteWater'],.9*[1 1 1]);
    
end

makethisone=0;

if makethisone==1

%% now time series and table.
fid=fopen('MethaneNumbers.csv','w');
yrvect=1999:2019;
    for j=1:length(ISOlist)
        ISO=ISOlist{j}
    for jyr=1:numel(yrvect);
        YYYY=yrvect(jyr);
        
        [M, rows, cols, A, B, OE, IND, T]=AllocateEmissionsNFIRevG(ISO,YYYY);
        
        LULUCF=SpatializeRegionalLULUCF_Emissions(ISO);
        
        ii=geo.raster0==j;
        
        CH4Fugitive(jyr)=sum(sum(M([icf iof],5:8)));
        CH4Solid(jyr)=sum(sum(M([iburn itreat],5:8)));
        CH4WW(jyr)=sum(sum(M([iwastewater],5:8)));
        
        
    end
    N=numel(CH4WW);
    Y=CH4WW.';
    X=[ones(N,1) (1:N).'] ;
    [b bint]=regress(Y,X);
    
    WWSlope=b(2);
    
    Ylin=X*b;
    
    peryearchange=(Ylin(end)-Ylin(1))/numel(Ylin);
    relativeperyearchange=peryearchange/mean(Ylin);
    
    
    CH4WW_PercentPerYearChange_map(ii)=relativeperyearchange*100;
    
    
end

nsg(CH4WW_PercentPerYearChange_map,'caxis',[-5 5])
fclose(fid);
end
%% now make a table including per capita - so limit to 2000:5:2020

fid=fopen('MethaneNumbersPerCapita.csv','w');
fprintf(fid,'ISO,year,WW,Pop,WWpercapita,SolidWaste,Fugitive\n');
yrvect=[2000 2005 2010 2015 2019];

% load all population layers





P(1).pop=DESDataGateway('Population',2000);
P(2).pop=DESDataGateway('Population',2005);
P(3).pop=DESDataGateway('Population',2010);
Pop2015=DESDataGateway('Population',2015);
Pop2020=DESDataGateway('Population',2020);
P(4).pop=Pop2015;
P(5).pop=(Pop2015+4*Pop2020)/5;

clear CH4WW CH4WWpc
for j=1:256
    j
    for jyr=1:numel(yrvect);
        YYYY=yrvect(jyr);
        ISO=geo.gadm0codes{j};
        
        [M, rows, cols, A, B, OE, IND, T]=AllocateEmissionsNFIRevG(ISO,YYYY);
        
     %   LULUCF=SpatializeRegionalLULUCF_Emissions(ISO);
        
        ii=geo.raster0==j;
        
        CH4Fugitive(jyr)=sum(sum(M([icf iof],5:8)));
        CH4Solid(jyr)=sum(sum(M([iburn itreat],5:8)));
        CH4WW(jyr)=sum(sum(M([iwastewater],5:8)));
 
        Population=sum(P(jyr).pop(ii));

        
        CH4WWpc(jyr)=CH4WW(jyr)/Population;
        
        fprintf(fid,'%s,%d,%f,%f,%f,%f,%f\n',ISO,YYYY,CH4WW(jyr),Population,CH4WWpc(jyr),CH4Solid(jyr),CH4Fugitive(jyr))
    end
    
    %% trend in CH4 in WW  (calculate this - should agree with calculation above over every year)
    N=numel(CH4WW);
    Y=CH4WW.';
    X=[ones(N,1) ([0 5 10 15 19]).'] ;
    [b bint]=regress(Y,X);    
    WWSlope=b(2);    
    Ylin=X*b;    
    peryearchange=(Ylin(end)-Ylin(1))/20;
    relativeperyearchange=peryearchange/mean(Ylin);
 
    CH4WW_PercentPerYearChange_map(ii)=relativeperyearchange*100;
 
    
    %% trend in per-capita CH4
    N=numel(CH4WWpc);
    Y=CH4WWpc.';
    X=[ones(N,1) ([0 5 10 15 19]).'] ;
    [b bint]=regress(Y,X);    
    WWpcSlope=b(2);    
    Ylin=X*b;    
    peryearchange=(Ylin(end)-Ylin(1))/20;
    relativeperyearchange=peryearchange/mean(Ylin);
 
    CH4WW_percapita_PercentPerYearChange_map(ii)=relativeperyearchange*100;

    
    CH4WW_percapita2019(ii)=CH4WWpc(5);
    
end

fclose(fid);



clear NSS
NSS.caxis=[-5 5];
NSS.title=['Waste water methane per capita.  Annual trend'];
NSS.units='percent change per year';
NSS.filename='on';
nsg(CH4WW_percapita_PercentPerYearChange_map,NSS)

clear NSS
NSS.caxis=[-5 5];
NSS.title=['Waste water methane.  Annual trend. (calculated in population years)'];
NSS.units='percent change per year';
NSS.filename='on';
nsg(CH4WW_PercentPerYearChange_map,NSS)

clear NSS
NSS.caxis=[.95];
NSS.title=['Waste water methane per capita.  2019'];
NSS.units='wasn''t paying attention';
NSS.filename='on';
nsg(CH4WW_percapita2019,NSS)




