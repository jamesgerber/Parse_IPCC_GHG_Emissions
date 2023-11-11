function ParseAndDisplayEmissions_WasteTimeSeries(ISOlist,RegionName)

% prepare ISOlist
if ischar(ISOlist)
    ISOlist={ISOlist};
end

if nargin==1
    RegionName=[ISOlist{1}];
    if numel(ISOlist)>1
        j=2:min(numel(ISOlist),6)
        RegionName=[RegionName '_' ISOlist{j}];
    end
    if numel(ISOlist)>6
        RegionName=[RegionName '_etc'];
    end
end


yearvect=1970:2019;

for jISO=1:numel(ISOlist)
    ISO=ISOlist{jISO};
    
    for jyear=1:numel(yearvect);
        YYYY=yearvect(jyear);
        [M,rows,cols,A,B,OE,IND,T]=AllocateEmissionsNFI(ISO,YYYY);
        
        irow=strmatch('industry_waste',rows);
        
        jjCH4=5:8;
        CH4Waste(jyear)=sum(M(irow,jjCH4));
        
        
        
        [CO2eqBioTreatSW(jyear),CH4BioTreatSW(jyear)]=getEdgarData(ISO,'CH4','Biological Treatment of Solid Waste',YYYY);
        [CO2eqWastewater(jyear),CH4Wastewater(jyear)]=getEdgarData(ISO,'CH4','Wastewater Treatment and Discharge',YYYY);
        [CO2eqIncineration(jyear),CH4Incineration(jyear)]=getEdgarData(ISO,'CH4','Incineration and Open Burning of Waste',YYYY);
        [CO2eqSolidWaste(jyear),CH4SolidWaste(jyear)]=getEdgarData(ISO,'CH4','Solid Waste Disposal',YYYY);
    end
    
    if jISO==1
        CH4WasteSum=CH4Waste;
        
        CO2eqBioTreatSWSum=CO2eqBioTreatSW;
        CO2eqWastewaterSum=CO2eqWastewater;
        CO2eqSolidWasteSum=CO2eqSolidWaste;
        CO2eqIncinerationSum=CO2eqIncineration;
        
        CH4BioTreatSWSum=CH4BioTreatSW;
        CH4WastewaterSum=CH4Wastewater;
        CH4SolidWasteSum=CH4SolidWaste;
        CH4IncinerationSum=CH4Incineration;
        
        
    else
        CH4WasteSum=CH4WasteSum+CH4Waste;
        
        CO2eqBioTreatSWSum=CO2eqBioTreatSWSum+CO2eqBioTreatSW;
        CO2eqWastewaterSum=CO2eqWastewaterSum+CO2eqWastewater;
        CO2eqSolidWasteSum=CO2eqSolidWasteSum   +CO2eqSolidWaste;
        CO2eqIncinerationSum=CO2eqIncinerationSum+CO2eqIncineration;

        CH4BioTreatSWSum=CH4BioTreatSWSum+CH4BioTreatSW;
        CH4WastewaterSum=CH4WastewaterSum+CH4Wastewater;
        CH4SolidWasteSum=CH4SolidWasteSum   +CH4SolidWaste
        CH4IncinerationSum=CH4IncinerationSum+CH4Incineration;

    end
end

Y=[(CO2eqBioTreatSWSum+CO2eqIncinerationSum);CO2eqWastewaterSum;CO2eqSolidWasteSum];
%%
figure,area(yearvect,Y.'),hold on,plot(yearvect,CH4WasteSum/1e3,'x')
title(['Breakdown of Waste, Industrial. ' RegionName])
ylabel(['CO2-eq'])
legend('Burning/Treating of Solid Waste','Wastewater Treatment','Solid Waste Disposal','Minx et al, Waste')
reallyfattenplot

figure,plot(yearvect,CH4WastewaterSum)
title(['Methane emissions from Wastewater Treatment. ' RegionName])
ylabel(['CH_4'])
reallyfattenplot



Y=[(CH4BioTreatSWSum+CH4IncinerationSum );CH4WastewaterSum;CH4SolidWasteSum];
%%
figure,area(yearvect,Y.'),hold on,plot(yearvect,CH4WasteSum/1e3/28,'x')
title(['Breakdown of Waste, Industrial. ' RegionName])
ylabel(['CH4'])
legend('Burning/Treating of Solid Waste','Wastewater Treatment','Solid Waste Disposal','Minx et al, Waste')
reallyfattenplot




