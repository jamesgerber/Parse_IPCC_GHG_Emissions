function   [CH4BioTreatSW,CH4Wastewater,CH4SolidWaste,CH4Incineration,...
    N2OBioTreatSW,N2OWastewater,N2OIncineration]=GetRegionalEdgarWasteAllocation(ISO,YYYY);


persistent c
if isempty(c)
    c=readgenericcsv('essd_ghg_data_gwp100_datasheet.txt',1,tab);
end


% what is region

idx=strmatch(ISO,c.ISO);

r10=c.region_ar6_10(idx(1));


% get all other countries in region

idx=strmatch(r10,c.region_ar6_10);

othercountries=unique(c.ISO(idx));



tmp=zeros(1,7);
for j=1:numel(othercountries)
ISO=othercountries{j};
    
    [CO2eqBioTreatSW,CH4BioTreatSWvect(j)]=getEdgarData(ISO,'CH4','Biological Treatment of Solid Waste',YYYY);
    [CO2eqWastewater,CH4Wastewatervect(j)]=getEdgarData(ISO,'CH4','Wastewater Treatment and Discharge',YYYY);
    [CO2eqSolidWaste,CH4SolidWastevect(j)]=getEdgarData(ISO,'CH4','Solid Waste Disposal',YYYY);
    [CO2eqIncineration,CH4Incinerationvect(j)]=getEdgarData(ISO,'CH4','Incineration and Open Burning of Waste',YYYY);
    [CO2eqBioTreatSW,N2OBioTreatSWvect(j)]=getEdgarData(ISO,'N2O','Biological Treatment of Solid Waste',YYYY);
    [CO2eqWastewater,N2OWastewatervect(j)]=getEdgarData(ISO,'N2O','Wastewater Treatment and Discharge',YYYY);
    %[CO2eqSolidWaste,N2OSolidWaste]=getEdgarData(ISO,'N2O','Solid Waste Disposal',YYYY);
    [CO2eqIncineration,N2OIncinerationvect(j)]=getEdgarData(ISO,'N2O','Incineration and Open Burning of Waste',YYYY);

end

CH4BioTreatSW=sum(CH4BioTreatSWvect);
CH4Wastewater=sum(CH4Wastewatervect);
CH4SolidWaste=sum(CH4SolidWastevect);
CH4Incineration=sum(CH4Incinerationvect);
N2OBioTreatSW=sum(N2OBioTreatSWvect);
N2OWastewater=sum(N2OWastewatervect);
N2OIncineration=sum(N2OIncinerationvect);