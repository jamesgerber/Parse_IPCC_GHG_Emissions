% let's see if summing emissions that I calculate agree with EDGAR
% country-level

[E10,E7]=holdEDGAR;

ISO='USA';

% time series ...

E7CO2=WideToLong(E7.EdgarEmissions_CO2_CountryTot);
E7N2O=WideToLong(E7.EdgarEmissions_N2O_CountryTot);
E7CH4=WideToLong(E7.EdgarEmissions_CH4_CountryTot);
tmp=AggregateFgasesWithinISOByGWP(E7.EdgarEmissions_Fgas_CountryTot);
tmp.Country_code_A3=tmp.Country_code_A3(:);
E7Fgas=WideToLong(tmp);


yrvect=2000:2019;

for jyr=1:numel(yrvect);
    YYYY=yrvect(jyr);
    emsco2(jyr)=pullfromsov(E7CO2,'Value','Country_code_A3',ISO,'Year',YYYY);
    emsch4(jyr)=pullfromsov(E7CH4,'Value','Country_code_A3',ISO,'Year',YYYY);
    emsn2o(jyr)=pullfromsov(E7N2O,'Value','Country_code_A3',ISO,'Year',YYYY);
    emsFgas(jyr)=pullfromsov(E7Fgas,'Value','Country_code_A3',ISO,'Year',YYYY);
end

emsGtCO2eq=emsco2/1000+emsch4*28/1000+emsn2o*278/1000+emsFgas/1e6;

figure,plot(yrvect,emsGtCO2eq)
title(['EDGAR 7 emissions, USA'])
reallyfattenplot
zeroylim(5600,7400)
outputfig('force',['figures/emissions' ISO 'EDGAR7.png'])
cd figures
invertplot 1
cd ../


% timeseries

ISO='DEU';
yrvect=2000:2024;

for j=1:25;
    M=AllocateEmissions2026update(ISO,yrvect(j));
    Emissions(j)=sum(M(:));

    if yrvect(j)<2020;
        M=AllocateEmissionsNFIRevH(ISO,yrvect(j));
    else
        M=nan;
    end

    EmissionsOld(j)=sum(M(:));

end
plot(yrvect,Emissions,yrvect,EmissionsOld,'x')
title(['emissions time series ' ISO]);
reallyfattenplot
outputfig('force',['figures/emissions' ISO '.png'])
cd figures
invertplot 1
cd ../

