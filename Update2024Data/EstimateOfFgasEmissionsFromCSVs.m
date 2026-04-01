yrvect=2019:2024;

figure

ISOlist=MinxCountriesList;

%ISOlist={'CHN'}
clear countrysum

for j=1:numel(ISOlist)
for jyr=1:6;
YYYY=yrvect(jyr);

    ISO=ISOlist{j};

    a=readgenericcsv(['intermediatefiles/csvs/Emissions' ISO '_GWP100_' int2str(YYYY) '.csv']);

   % countrysum=sum(a.Fgas_elec+a.Fgas_fossil+a.Fgas_process+a.Fgas_biogenic);
sumbyyear(jyr)=sum(a.Fgas_elec+a.Fgas_fossil+a.Fgas_process+a.Fgas_biogenic);
end


plot(sumbyyear)
title(ISO)
outputfig('force',['stupidfigures/' ISO '.png'])
%sumbyyear(jyr)=sum(countrysum);

end