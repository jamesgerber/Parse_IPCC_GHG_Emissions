%function constructcsvs
% % %


global GWPFLAG
GWPFLAG=20



ISOlist=MinxCountriesList;
% 
%ISOlist={'CHN'};
for YYYY=[2017:2024];
    for j=1:numel(ISOlist)
        ISO=ISOlist{j};
        MakeEmissionsCSVFile_updated(ISO,YYYY,['intermediatefiles/csvs/Emissions' ISO '_GWP' int2str(GWPFLAG) '_' num2str(YYYY)  '.csv']);
    end
end


%crash


% grab this - will make writing out csv easier later
a=readgenericcsv(['intermediatefiles/csvs/Emissions' 'USA' '_GWP100_' '2019.csv']);

% now combine csvs
for YYYY=[ 2019:2024];
YYYYvect=(YYYY-2):(YYYY)

ISOlist=MinxCountriesList;

for j=1:numel(ISOlist)
    ISO=ISOlist{j};

    clear X
    for jyr=1:numel(YYYYvect)
        X(:,:,jyr)=readmatrix(['intermediatefiles/csvs/Emissions' ISO '_GWP' int2str(GWPFLAG) '_' num2str(YYYYvect(jyr)) '.csv']);

    end
    Xlatestyear=detrendaverage(X,numel(YYYYvect));

    %keyboard

    filename=['individualcsvs/ThreeYearAvg' ISO '_GWP' int2str(GWPFLAG) '_' int2str(YYYY) '.csv'];
    clear WriteStruct
    WriteStruct.Rows=a.Rows;;

    cols=fieldnames(a);
    cols=cols(2:end)
    for j=1:16
        WriteStruct.(cols{j})=Xlatestyear(:,j+1);
    end
    struct2csv(filename,WriteStruct);
end

% now add up the individual ones

clear X
for j=1:numel(ISOlist)
    ISO=ISOlist{j};
    filename=['individualcsvs/ThreeYearAvg' ISO '_GWP' int2str(GWPFLAG) '_' int2str(YYYY) '.csv'];
    X(:,:,j)=readmatrix(filename);
end

Xsum=nansum(X,3)

filename=['AllCountryEmissions_2026Update_ThreeYearAvg_to_' int2str(YYYY) '_GWP' int2str(GWPFLAG) '.csv'];
clear WriteStruct
WriteStruct.Rows=a.Rows;;

cols=fieldnames(a);
cols=cols(2:end)
for j=1:16
    WriteStruct.(cols{j})=Xsum(:,j+1);
end
struct2csv(filename,WriteStruct);


end
