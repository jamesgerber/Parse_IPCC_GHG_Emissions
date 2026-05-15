
% for geoflag=0:4;
%     switch geoflag
%         case 0
% 
             ISOlist=MinxCountriesList;

             clear ISOlist;
for geoflag=1:numel(MinxCountriesList);
    ISOlist{1}=MinxCountriesList(geoflag);
    geostring=char(ISOlist{1});
%             geostring='World';
%         case 1
%             ISOlist={'USA'};
%             geostring='USA';
%         case 2
%             ISOlist={'BRA'};
%             geostring='BRA';
%         case 3
%             ISOlist={'CHN'};
%             geostring='CHN';
%         case 4
%             ISOlist={'FRA'};
%             geostring='FRA';
%     end

    a=readgenericcsv(['intermediatefiles/csvs/Emissions' 'USA' '_GWP100_' '2019.csv']);


    GWPFLAG=100;

    yrvect=1972:2024;

    clear DS
    DS.year=yrvect;
    for jyr=1:numel(yrvect);

        YYYY=yrvect(jyr);
        clear X
        for j=1:numel(ISOlist)
            ISO=ISOlist{j};
            filename=['individualcsvs/ThreeYearAvg' ISO '_GWP' int2str(GWPFLAG) '_' int2str(YYYY) '.csv'];
            X(:,:,j)=readmatrix(filename);
        end

        Xsum=nansum(X,3);

        DS.TotalEmissions(jyr)=sum(sum(Xsum));


        DS.OnFarm(jyr)=sum(sum(Xsum(1:6,:)));
        DS.LULUCF(jyr)=sum(sum(Xsum(7,:)));
        DS.Buildings(jyr)=sum(sum(Xsum(8:10,:)));
        DS.Electricity(jyr)=sum(sum(Xsum(11:20,:)));
        DS.OtherEnergy(jyr)=sum(sum(Xsum(21:24,:)));
        DS.Industry(jyr)=sum(sum(Xsum(25:31,:)));
        DS.Transport(jyr)=sum(sum(Xsum(32:38,:)));
        DS.AgSector(jyr)=sum(sum(Xsum(1:7,:)));

    end
    DS.TotalNonLULUCFEmissions=DS.TotalEmissions-DS.LULUCF;

    sov2csv(DS,['EmissionsTimeSeries/emissionstimeseries' geostring '.csv'])

end