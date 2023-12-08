function layer=DESDataGateway(name,YYYY,ISO);
% DESDataGateway - gateway function to get data for DES explorer
%
% return 5minute datasets.
%
%Syntax
%  layer=DESDataGateway('population',2020) will return a layer of
%  population data from ciesin
%
%  GDPvect=DESDataGateway('gdp',yrvect,ISO) will return a vector of
%  GDP data (in constant USD) from World Bank Data
%

ParseGHGDataConstantsDefaults; % to define DataFilesLocation

DataProductsDir='~/DataProducts/ext/';
YSTR=num2str(YYYY);


switch lower(name)
    case {'population','pop'}
        %% Population
        
        popdir=[DataProductsDir 'Population/'];
        switch YYYY
            case {2000,2005,2010,2015,2020}
                
                if exist([DataFilesLocation '/DESDataGatewayFiles/' ...
                        'gpw-v4-population-count-adjusted-to-2015-unwpp-country-totals-rev11_' YSTR '_5min.mat'])==2
                    load([DataFilesLocation '/DESDataGatewayFiles/' ...
                        'gpw-v4-population-count-adjusted-to-2015-unwpp-country-totals-rev11_' YSTR '_5min.mat'],'layer')
                else
                    if isoctave
                        error(['oops this is ugly.  should have found a directory with a matfile in it.  ask James.']);
                    end
                    
                    [A,R]=geotiffread([popdir ...
                        'gpw-v4-population-count-adjusted-to-2015-unwpp-country-totals-rev11_' YSTR '_2pt5_min_tif/' ...
                        'gpw_v4_population_count_adjusted_to_2015_unwpp_country_totals_rev11_' YSTR '_2pt5_min.tif']);
                    A(A<0)=0;
                    layer=aggregate_quantity(A,2).';
                    save([DataFilesLocation '/DESDataGatewayFiles/' ...
                        'gpw-v4-population-count-adjusted-to-2015-unwpp-country-totals-rev11_' YSTR '_5min.mat'],'layer')

                end
                    
            otherwise
                error('no population data for this year')
                        
                        
        end
     
    case {'gdp'};
        
        persistent rawGDPData yearrows
        if isempty(rawGDPData)
            rawGDPData=readgenericcsv([DataFilesLocation '/GDP/WorldBank/GDPTransposed.txt'],2,tab,1);
            yearrows=str2double(rawGDPData.Country_Code);
        end
        
        x=fieldnames(rawGDPData);
        
        idx=strmatch(ISO,x);
        
        if numel(idx)==0
            layer=nan*YYYY;
        else
            y=str2double(rawGDPData.(ISO));
            
            for j=1:numel(YYYY);
                idx=find(yearrows==YYYY(j));
                gdpval=y(idx);
                if isnan(gdpval)
                    % ok ... find closest value
                    
                    for m=1:20% this is horrendously ugly ... expand out from idx until you find a gdp value
                        wlow=y(idx-1);
                        whigh=y(min(idx+1,numel(y)));
                        if isfinite(wlow)
                            gdpval=wlow;
                            break
                        elseif isfinite(whigh)
                            gdpval=whigh;
                            break
                        else
                            % do nothing
                        end
                    end
                    if m==20
                        gdpval=nan;
                    end
                    
                end
                layer(j)=gdpval;

            end
        end
        
        
        
end