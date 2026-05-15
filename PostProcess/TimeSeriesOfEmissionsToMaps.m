ISOlist=MinxCountriesList;


FieldList={'TotalEmissions','LULUCF','OnFarm',...
    'Buildings','Electricity','OtherEnergy','Industry','Transport','AgSector'};

NameList={'Total','LULUCF','On Farm',...
    'Building','Electricity','Other Energy','Industry','Transport','On farm + LULUCF'};


for startyear = [2015 2005 1995]

for jouter=1:length(FieldList)
FieldToAnalyze=FieldList{jouter}
SectorName=NameList{jouter};
PerCapitaFlag=0;
PerGDPFlag=0;
map=datablank;
%                    year: [53×1 double]
%          TotalEmissions: [53×1 double]
%                  OnFarm: [53×1 double]
%                  LULUCF: [53×1 double]
%               Buildings: [53×1 double]
%             Electricity: [53×1 double]
%             OtherEnergy: [53×1 double]
%                Industry: [53×1 double]
%               Transport: [53×1 double]
% TotalNonLULUCFEmissions: [53×1 double]

yrvect=startyear:2024;

daterange=[int2str(yrvect(1)) '-' int2str(yrvect(end))];

for geoflag=1:numel(MinxCountriesList);
    ISOcell=MinxCountriesList(geoflag);
    ISO=char(ISOcell);
    geostring=char(ISOcell);
    a=readgenericcsv(['EmissionsTimeSeries/emissionstimeseries' ISO '.csv']);
    y=a.(FieldToAnalyze);
    ii=find(ismember(a.year,yrvect));

    ytemp=y(ii);
    ytemp=ytemp(:);

    try
        [~,iimap]=getgeo41_g0(ISO);

        if PerCapitaFlag==1
            [POPdata,years,version]=ReturnWorldBankPopulationTimeSeries(ISO,yrvect);
            yanalyze=ytemp./POPdata(:)*1e9;
            units='tons CO2-eq/person/yr/yr';
            titlestring=['Change in ' SectorName ' Emissions per capita ' daterange];
        elseif PerGDPFlag==1
            [GDPdata,years,version]=ReturnWorldBankGDPTimeSeries(ISO,yrvect);
            yanalyze=ytemp./GDPdata(:)*1e9*1e4;
            units='tons CO2-eq/$10000/yr/yr';
            titlestring=['Change in ' SectorName ' Emissions per unit pcGDP ' daterange];
        else
            units='Gt CO2-eq/yr';
            titlestring=['Change in ' SectorName ' Emissions. ' daterange];
            yanalyze=ytemp;
        end

        [x0,x1,Rsq,p,sig]=VectorizedLinearRegression(yanalyze);

        maxdebug=0;

        if maxdebug==1

            figure
            hsp=subplot(311)
            hp=plot(yrvect,ytemp)
            grid on
            ylabel('Gt CO2-eq')
            title(['Emissions ' ISO]);

            subplot(312)
            plot(yrvect,GDPdata/1e9);
            ylabel('$B');
            title(['GDP ' ISO]);
            grid on

            subplot(313)
            plot(yrvect,yanalyze,yrvect,(yrvect-yrvect(1))*x1+x0)
            ylabel('tCO2-eq / $10000 GDP');
            title(['Emissions intensity ' ISO]);
            grid on

            fattenplot
            outputfig('Force','figures/')
            cd figures/
            invertplot 1
            cd ../

        end








        if sig==1;

            map(iimap)=x1;
        else
            map(iimap)=nan;
        end
    catch
        disp(['no geodata for ' ISO])
    end

end

if min(map(:))*max(map(:))<0
    % whew! we can stretch the colormap

  %  cmap='revdark_beige_white_blue_deep';
    c1=finemap('dark_greens_deep','','');
    c2=finemap('dark_orange_red','','');
    cmap=[c1(end:-10:50,:); [1 1 1] ; [1 1 1] ; 1 1 1 ; c2(50:10:end,:)];
addstretch=1;
elseif min(map(:))==0
addstretch=0;
    % it's all bad news for every country!

    c2=finemap('dark_orange_red','','');
    cmap=c2;
    
end

    clear NSS
    if addstretch==1
        NSS.modifycolormap='stretch';
        NSS.stretchcolormapcentervalue=0;
    end
    NSS.title=titlestring;
    NSS.units=units;
    %NSS.filename='maps/'
    NSS.cmap=cmap;
    nsg(map,NSS)

    NSS=getDrawdownNSS;
    if addstretch==1
        NSS.modifycolormap='stretch';
        NSS.stretchcolormapcentervalue=0;
    end
    NSS.cmap=cmap;
    NSS.title=titlestring;
    NSS.units=units;
    DataToDrawdownFigures(map,NSS,makesafestring(titlestring),'mapsanddata');



end;

end