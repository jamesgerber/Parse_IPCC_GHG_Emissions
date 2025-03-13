function [S,allISO]=getIPCCSectorCountryLists;

% quick and dirty with hardwiring shame (frantically prepping APC round
% table talk)
persistent astore

if isempty(astore)

a=readgenericcsv('/Users/jsgerber/sandbox/jsg203_ClimateSolutionsExplorer/essd_ghg_data_datasheet.txt',1,tab);



astore=a;
end

a=astore;


ar6_10=unique(a.region_ar6_10);


c=0;
for j=[1:5 8:12];
    c=c+1;
    S(c).regionname=ar6_10{j};

    ii=strmatch(ar6_10{j},a.region_ar6_10);

    S(c).ISOlist=unique(a.ISO(ii));
end

allISO=unique(a.ISO);