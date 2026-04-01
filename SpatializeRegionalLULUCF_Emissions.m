function [C]=SpatializeRegionalLULUCF_Emissions(ISO,YYYY);

persistent  NormalizedCarbonValueList NormalizedCarbonISOList

if isempty(NormalizedCarbonValueList)
    load ~/sandbox/jsg203_ClimateSolutionsExplorer/DisaggregatedLULUCFCarbonByCountryRev0 NormalizedCarbonValueList NormalizedCarbonISOList
end


idx=strmatch(ISO,NormalizedCarbonISOList);

if isempty(idx)
    C=0;
else
    C=NormalizedCarbonValueList(idx);
end




return

% code that makes DisaggregatedLULUCFCarbonByCountryRev0.mat

% spatialize regional lulucf_emissions

a=readgenericcsv('essd_ghg_data_datasheet.txt',1,tab);
b=readgenericcsv('essd_lulucf_data_datasheet.txt',1,tab);
b1=subsetofstructureofvectors(b,find(b.year==YYYY));

[long,lat,lossyear]=processgeotiff('spatializeLULUCF/lossyear-2.tif');

%%
% [long,lat,ecoregions]=processgeotiff('spatializeLULUCF/Ecoregions2017_compressed_md5_316061.tif');
% %prepare carbon table stuff
%
% long5=aggregate_rate(long,30);
% lat5=aggregate_rate(lat,30);
% ecoregions5=aggregate_rate(ecoregions,30,'mode','uint16');
%
% [long,lat]=inferlonglat;
%
% [~,j1]=closestvalue(lat,lat5(1));
% [~,j2]=closestvalue(lat,lat5(end));
%
% ecoregions=datablank;
% ecoregions(:,j1:j2)=ecoregions5;
%
% save spatializeLULUCF/ecoregions5minutes ecoregions

load spatializeLULUCF/ecoregions5minutes ecoregions

ct=readgenericcsv('spatializeLULUCF/carbon_table_2022-08-10.csv');

%% some ESA crap
%[ESA,R]=geotiffread('spatializeLULUCF/ESACCI-LC-L4-LCCS-Map-300m-P1Y-2015-v2.0.7_md5_1254d25f937e6d9bdee5779d377c5aa4.tif');
%ESA5minModal=aggregate_rate(ESA,30,'mode','uint8');
%ESA5minModal=ESA5minModal';
%save ESA5minModal ESA5minModal
load ESA5minModal.mat

%%
load /Users/jsgerber/DataProducts/ext/GADM/GADM41/gadm41_level0raster5minVer0
%%

listofregions=unique(b.region_ar6_10);
megaregionlist=datablank;

clear CarbonRegionList
for j=1:numel(listofregions);
    
    thisregion=listofregions{j}
    
    idx=strmatch(thisregion,a.region_ar6_10);
    
    ISOlist=unique(a.ISO(idx))
    countrylist=unique(a.country(idx))
    thisregion
    
    
    idx=strmatch(thisregion,b1.region_ar6_10);
    
    MinxRegionalCarbon(j)=b1.mean(idx);
    
    
    switch thisregion
        
        case 'Africa'
            ISOlist{end+1}='SSD'
            
        case 'Eastern Asia'
            ISOlist=setdiff(ISOlist,'HKG');
            ISOlist=setdiff(ISOlist,'MAC');
            
        case 'Eurasia'
            ISOlist=setdiff(ISOlist,'SCG');
            
        case 'Latin America and Caribbean'
            ISOlist=setdiff(ISOlist,'ANT');
            
    end
    
    regionmap=datablank;
    
    clear CarbonCountryList
    for m=1:numel(ISOlist)
        ISO=ISOlist{m};
        
        
        idx=strmatch(ISO,gadm0codes)
        if numel(idx)~=1
            keyboard
        end
        
        ii=raster0==idx;
        
        regionmap=regionmap+ii;
        
        % now calculate carbon associated with ii
        
        jj=find(ii & (lossyear==19|lossyear==18|lossyear==20));
        
        ecoregionlist=ecoregions(jj);
        
        
        if numel(jj)>0
            % how much carbon here lost due to land use change?
            %pre-normalization calculation.
            clear carbonvalue
            for k=1:numel(jj)
                
                thisecoregion=ecoregions(jj(k));
                
                if thisecoregion==0
                    carbonvalue(k)=0;
                else
                    thisESAcategory=ESA5minModal(jj(k));
                    
                    irow=find(ct.Ecoregion==thisecoregion);
                    
                    field=ct.(['Val' int2str(thisESAcategory)]);
                    
                    carbonvalue(k)=field(irow).*fma(jj(k));
                end
            end
            
            
            CarbonCountryList(m)=sum(carbonvalue(k));
        else
            CarbonCountryList(m)=0;
        end
        
        
    
        
        
    end
    
    NormalizedCarbonValue=CarbonCountryList.*MinxRegionalCarbon(j)/sum(CarbonCountryList);

    
    if j==1
        NormalizedCarbonValueList=NormalizedCarbonValue;
        NormalizedCarbonISOList=ISOlist;
    else
        NormalizedCarbonValueList(end+1:(end+numel(ISOlist)))= NormalizedCarbonValue;
        NormalizedCarbonISOList(end+1:(end+numel(ISOlist)))=ISOlist;
    
    end
    
    
    CarbonRegionList(j)=sum(CarbonCountryList);
    megaregionlist=megaregionlist+regionmap;
    
    
    
    
    
    % how much carbon here?
    
    
end

figure,scatter(CarbonRegionList,MinxRegionalCarbon)
xlabel('Carbon calculation')
ylabel('Minx-reported regional')
grid on
reallyfattenplot
title('carbon emissions from LULUCF')
outputfig('Force')

save DisaggregatedLULUCFCarbonByCountryRev0 NormalizedCarbonValueList NormalizedCarbonISOList
%%

