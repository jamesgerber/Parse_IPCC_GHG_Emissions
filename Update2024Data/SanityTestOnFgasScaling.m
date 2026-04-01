% here is a sanity test on f-gas scaling

% if i'm understanding things, I should be able to recreated the GWP100
% version of the F-gas EDGAR spreadsheet.

ISO='CHN';
YYYY=2019;
valcol=['Y_' int2str(YYYY)];

AR5=load('~/DataProducts/ext/EDGAR/Feb11_2026/processeddata/EdgarV2025_Fgas100yrGWP.mat')
x =load('~/DataProducts/ext/EDGAR/Feb11_2026/processeddata/EdgarV2025.mat')

y=x.EdgarEmissions_Fgas_CountryTot;
y5=AR5.EdgarEmissions_Fgas100yrGWP_CountryTot;

% first calculate from AR5

ii=strmatch(ISO,y5.Country_code_A3);
AR5Value=sum(y5.(valcol)(ii))


% now calculate from other one

ii=strmatch(ISO,y.Country_code_A3);


gwpsum=0;
for m=1:numel(ii)
    [gwp20,gwp100]=substancetoGWP_AR5(y.Substance(ii(m)));
    gwpsum=gwpsum+y.(valcol)(ii(m))*gwp100;
end
gwpsum

