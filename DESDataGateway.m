function layer=DESDataGateway(name,YYYY);
% DESDataGateway - gateway function to get data for DES explorer
%
% return 5minute datasets.
%
%Syntax
%  layer=DESDataGateway('population',2020)


DataProductsDir='~/DataProducts/ext/';
YSTR=num2str(YYYY);


switch lower(name)
    case {'population','pop'}
            %% Population

        popdir=[DataProductsDir 'Population/'];
        switch YYYY
            case {2000,2005,2010,2015,2020}
        
                [A,R]=geotiffread([popdir ...
                    'gpw-v4-population-count-adjusted-to-2015-unwpp-country-totals-rev11_' YSTR '_2pt5_min_tif/' ...
                    'gpw_v4_population_count_adjusted_to_2015_unwpp_country_totals_rev11_' YSTR '_2pt5_min.tif']);
                A(A<0)=0;
                layer=aggregate_quantity(A,2).';

                
            otherwise
                error('no population data for this year')
        
        
        end
      
end         