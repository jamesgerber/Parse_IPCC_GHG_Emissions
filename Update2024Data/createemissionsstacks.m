
ISOlist=MinxCountriesList;
yrvect=1972:2024;
for GWPFLAG=[100];


for j=1:numel(ISOlist);
    ISO=ISOlist{j};

    for jyr=1:numel(yrvect);
        YYYY=yrvect(jyr);


        a=readmatrix(...
            ['individualcsvs/' ...
            'ThreeYearAvg' ISO '_GWP' int2str(GWPFLAG) ...
            '_' int2str(YYYY) '.csv']);

        Mstack(:,:,jyr)=a(:,2:end);

    end
    version={'RevC April 1 2026'};

    save(['emissionsstacks/' ISO '_' int2str(GWPFLAG)],'Mstack','yrvect','version');


end
end