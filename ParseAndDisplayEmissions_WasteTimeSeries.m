function ParseAndDisplayEmissions_WasteTimeSeries(ISOlist,RegionName)
% ParseAndDisplayEmissions_WasteTimeSeries make a plot of waste time series
%
%  this makes a plot of waste time series.  Historically this was written
%  before AllocateEmissionsNFIRevH which breaks out the waste data into
%  biological+incineration; wastewater;Incineration.  
% 
% so it's not really parsing anymore, just displaying
%
%  Syntax:
%     ParseAndDisplayEmissions_WasteTimeSeries(ISOlist,RegionName)
%
%     ParseAndDisplayEmissions_WasteTimeSeries('USA','United States')
%     ParseAndDisplayEmissions_WasteTimeSeries({'USA','CAN',MEX'},...
%     'North America emissions');
%

% James Gerber
% Project Drawdown


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
        
        %%% super ugly to code this way - but here's the old version when
        %%% this actually parsed.
        % [M,rows,cols,A,B,OE,IND,T]=AllocateEmissionsNFI(ISO,YYYY);
        % 
        % irow=strmatch('industry_waste',rows);
        % jjCH4=5:8;
        % CH4Waste(jyear)=sum(M(irow,jjCH4));
        % 
        % [CO2eqBioTreatSW(jyear),CH4BioTreatSW(jyear)]=getEdgarData(ISO,'CH4','Biological Treatment of Solid Waste',YYYY);
        % [CO2eqWastewater(jyear),CH4Wastewater(jyear)]=getEdgarData(ISO,'CH4','Wastewater Treatment and Discharge',YYYY);
        % [CO2eqIncineration(jyear),CH4Incineration(jyear)]=getEdgarData(ISO,'CH4','Incineration and Open Burning of Waste',YYYY);
        % [CO2eqSolidWaste(jyear),CH4SolidWaste(jyear)]=getEdgarData(ISO,'CH4','Solid Waste Disposal',YYYY);

        [M,rows,cols,A,B,OE,IND,T]=AllocateEmissionsNFIRevH(ISO,YYYY);

        irow1=strmatch('industry_burningtreatingsolidwaste',rows);
        irow2=strmatch('industry_solidwastedisposal',rows);
        irow3=strmatch('industry_wastewatertreatment',rows);

        jjCH4=5:8;
  %      CH4Waste(jyear)=sum(sum(M([irow1 irow2 irow3],jjCH4)));
        
         [~,a1]=getEdgarData(ISO,'CH4','Biological Treatment of Solid Waste',YYYY);
        [~,a2]=getEdgarData(ISO,'CH4','Wastewater Treatment and Discharge',YYYY);
         [~,a3]=getEdgarData(ISO,'CH4','Incineration and Open Burning of Waste',YYYY);
         [~,a4]=getEdgarData(ISO,'CH4','Solid Waste Disposal',YYYY);

         CH4Waste(jyear)=sum([a1 a2 a3 a4]);
        
    
        CO2eqBioTreatIncSW(jyear)=sum(M(irow1,jjCH4));
        CO2eqSolidWaste(jyear)=sum(M(irow2,jjCH4));
        CO2eqWastewater(jyear)=sum(M(irow3,jjCH4));

        CH4BioTreatIncSW=CO2eqBioTreatIncSW/28;
        CH4SolidWaste=CO2eqSolidWaste/28;
        CH4Wastewater=CO2eqWastewater/28;
    end
    
    if jISO==1
        CH4WasteSum=CH4Waste;
        
        CO2eqBioTreatIncSWSum=CO2eqBioTreatIncSW;
        CO2eqWastewaterSum=CO2eqWastewater;
        CO2eqSolidWasteSum=CO2eqSolidWaste;
        
        CH4BioTreatIncSWSum=CH4BioTreatIncSW;
        CH4WastewaterSum=CH4Wastewater;
        CH4SolidWasteSum=CH4SolidWaste;
        
        
    else
        CH4WasteSum=CH4WasteSum+CH4Waste;
        
        CO2eqBioTreatIncSWSum=CO2eqBioTreatIncSWSum+CO2eqBioTreatIncSW;
        CO2eqWastewaterSum=CO2eqWastewaterSum+CO2eqWastewater;
        CO2eqSolidWasteSum=CO2eqSolidWasteSum   +CO2eqSolidWaste;

        CH4BioTreatIncSWSum=CH4BioTreatIncSW+CH4BioTreatInc;
        CH4WastewaterSum=CH4WastewaterSum+CH4Wastewater;
        CH4SolidWasteSum=CH4SolidWasteSum   +CH4SolidWaste

    end
end

Y=[CO2eqBioTreatIncSWSum;CO2eqWastewaterSum;CO2eqSolidWasteSum];
%%
figure,area(yearvect,Y.'/1e3),hold on,plot(yearvect,CH4WasteSum*28,'x')
title(['Breakdown of Waste, Industrial. ' RegionName])
ylabel(['CO2-eq'])
legend('Burning/Treating of Solid Waste','Wastewater Treatment','Solid Waste Disposal','EDGAR Waste')
reallyfattenplot

figure,plot(yearvect,CH4WastewaterSum)
title(['Methane emissions from Wastewater Treatment. ' RegionName])
ylabel(['CH_4'])
reallyfattenplot



Y=[(CH4BioTreatIncSWSum);CH4WastewaterSum;CH4SolidWasteSum];
%%
figure,area(yearvect,Y.'/1e3),hold on,plot(yearvect,CH4WasteSum,'x')
title(['Breakdown of Waste, Industrial. ' RegionName])
ylabel(['CH4'])
legend('Burning/Treating of Solid Waste','Wastewater Treatment','Solid Waste Disposal','EDGAR, Waste')
reallyfattenplot




